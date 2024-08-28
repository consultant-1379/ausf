Feature: AMF authentication with 5G-AKA

  Scenario: Authentication Initiation Request
    Given target type is AUSF_HTTP
    Given path is /nausf-auth/v1/ue-authentications
    Given request header is Content-Type:application/json
    Given request content is
      """
      {
      "supiOrSuci":"suci-24081-0000-0-NULL-0000000012",
      "servingNetworkName":"5G:mnc081.mcc240.3gppnetwork.org"
      }
      """
    When we send POST request
    Then we expect response status code 201
    Then we expect response time less than 1100 milliseconds
    Then we expect response content text property authType equals 5G_AKA
    Then extract path from URI in response content property _links.5g-aka.href and save as authCtxId    
    Then compute resstar using 5G-AKA algorithm


  Scenario: Authentication Confirmation
    Given target type is AUSF_HTTP
    Given path is <authCtxId>
    Given request header is Content-Type:application/json
    Given request content is
      """
      {
      "resStar":"<resstar>"
      }
      """
    When we send PUT request
    Then we expect response status code 200
    Then we expect response content text property authResult equals AUTHENTICATION_SUCCESS
    Then we expect response time less than 1100 milliseconds
