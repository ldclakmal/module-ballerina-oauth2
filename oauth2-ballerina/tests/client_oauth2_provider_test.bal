// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// NOTE: All the tokens/credentials used in this test are dummy tokens/credentials and used only for testing purposes.

import ballerina/test;
import ballerina/lang.runtime as runtime;

// ---------------- CLIENT CREDENTIALS GRANT TYPE ----------------

// Test the client credentials grant type with valid credentials
@test:Config {
    groups: ["provider"]
}
isolated function testClientCredentialsGrantType1() {
    ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = new(config);
    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the client credentials grant type with invalid client credentials
@test:Config {
    groups: ["provider"]
}
isolated function testClientCredentialsGrantType2() {
    ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        clientId: "invalid_client_id",
        clientSecret: "invalid_client_secret",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "A valid OAuth client could not be found for client_id: invalid_client_id");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "A valid OAuth client could not be found for client_id: invalid_client_id");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the client credentials grant type with valid client-id and invalid client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testClientCredentialsGrantType3() {
    ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "invalid_client_secret",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client Authentication failed.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client Authentication failed.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the client credentials grant type with empty client-id and client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testClientCredentialsGrantType4() {
    ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        clientId: "",
        clientSecret: "",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the client credentials grant type with valid credentials
@test:Config {
    groups: ["provider"]
}
isolated function testClientCredentialsGrantType5() {
    ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:9090/oauth2/token",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = new(config);
    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // The access-token is valid only for 2 seconds. Wait 5 seconds and try again, so that the access-token will be
    // reissued by provided refresh configurations.
    runtime:sleep(5.0);

    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// ---------------- PASSWORD GRANT TYPE ----------------

// Test the password grant type with valid credentials
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType1() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        username: "admin",
        password: "admin",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = new(config);
    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with valid credentials and a valid refresh config
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType2() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9090/oauth2/token",
        username: "admin",
        password: "admin",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        refreshConfig: {
            refreshUrl: "https://localhost:9090/oauth2/token/refresh",
            scopes: ["view-order"],
            optionalParams: {
                "client": "ballerina"
            },
            clientConfig: {
                secureSocket: {
                   cert: {
                       path: TRUSTSTORE_PATH,
                       password: "ballerina"
                   }
                }
            }
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = new(config);
    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // The access-token is valid only for 2 seconds. Wait 5 seconds and try again, so that the access-token will get
    // refreshed by provided refresh configurations.
    runtime:sleep(5.0);

    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with an invalid username, password, and a valid refresh config
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType3() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        username: "invalid_username",
        password: "invalid_password",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        refreshConfig: {
            refreshUrl: "https://localhost:9443/oauth2/token",
            scopes: ["view-order"],
            optionalParams: {
                "client": "ballerina"
            },
            clientConfig: {
                secureSocket: {
                   cert: {
                       path: WSO2_TRUSTSTORE_PATH,
                       password: "wso2carbon"
                   }
                }
            }
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Authentication failed for invalid_username");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Authentication failed for invalid_username");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with an valid username, password, and empty client-id and client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType4() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        username: "admin",
        password: "admin",
        clientId: "",
        clientSecret: "",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with an valid username, password, and without client-id and client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType5() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9443/oauth2/token",
        username: "admin",
        password: "admin",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "invalid_client");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "invalid_client");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with an valid username, password, and without client-id and client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType6() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9090/oauth2/token",
        username: "admin",
        password: "admin",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        refreshConfig: {
            refreshUrl: "https://localhost:9090/oauth2/token/refresh",
            scopes: ["view-order"],
            optionalParams: {
                "client": "ballerina"
            },
            clientConfig: {
                secureSocket: {
                   cert: {
                       path: TRUSTSTORE_PATH,
                       password: "ballerina"
                   }
                }
            }
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // The access-token is valid only for 2 seconds. Wait 5 seconds and try again, so that the access-token will get
    // tried to refresh. But hence the client-id and client-secret are not provided, it will be failed.
    runtime:sleep(5.0);

    response = provider.generateToken();
    if (response is Error) {
        assertContains(response, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the password grant type with valid credentials and without refresh config
@test:Config {
    groups: ["provider"]
}
isolated function testPasswordGrantType7() {
    PasswordGrantConfig config = {
        tokenUrl: "https://localhost:9090/oauth2/token",
        username: "admin",
        password: "admin",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // The access-token is valid only for 2 seconds. Wait 5 seconds and try again, so that the access-token will get
    // tried to refresh. But hence the refresh configurations are not provided, it will be failed.
    runtime:sleep(5.0);

    response = provider.generateToken();
    if (response is Error) {
        assertContains(response, "Failed to refresh access-token since refresh configurations are not provided.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// ---------------- REFRESH TOKEN GRANT TYPE ----------------

// Test the refresh token grant type with an invalid refresh token
@test:Config {
    groups: ["provider"]
}
isolated function testRefreshTokenGrantType1() {
    RefreshTokenGrantConfig config = {
        refreshUrl: "https://localhost:9443/oauth2/token",
        refreshToken: "invalid_refresh_token",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Persisted access token data not found");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the refresh token grant type with an valid configurations
@test:Config {
    groups: ["provider"]
}
isolated function testRefreshTokenGrantType2() {
    RefreshTokenGrantConfig config = {
        refreshUrl: "https://localhost:9090/oauth2/token/refresh",
        refreshToken: "tGzv3JOkF0XG5Qx2TlKWIA",
        clientId: "FlfJYKBD2c925h4lkycqNZlC2l4a",
        clientSecret: "PJz0UhTJMrHOo68QQNpvnqAY_3Aa",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };
    ClientOAuth2Provider provider = new(config);
    string|Error response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // Send the credentials in request body
    config.credentialBearer = POST_BODY_BEARER;
    provider = new(config);
    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }

    // The access-token is valid only for 2 seconds. Wait 5 seconds and try again, so that the access-token will be
    // refreshed again by provided refresh configurations.
    runtime:sleep(5.0);

    response = provider.generateToken();
    if (response is string) {
        assertToken(response);
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}

// Test the refresh token grant type with empty client-id and client-secret
@test:Config {
    groups: ["provider"]
}
isolated function testRefreshTokenGrantType3() {
    RefreshTokenGrantConfig config = {
        refreshUrl: "https://localhost:9443/oauth2/token",
        refreshToken: "tGzv3JOkF0XG5Qx2TlKWIA",
        clientId: "",
        clientSecret: "",
        scopes: ["view-order"],
        optionalParams: {
            "client": "ballerina"
        },
        clientConfig: {
            secureSocket: {
               cert: {
                   path: WSO2_TRUSTSTORE_PATH,
                   password: "wso2carbon"
               }
            }
        }
    };
    ClientOAuth2Provider|error provider = trap new(config);
    if (provider is error) {
        assertContains(provider, "Client-id or client-secret cannot be empty.");
    } else {
        test:assertFail(msg = "Test Failed! ");
    }
}
