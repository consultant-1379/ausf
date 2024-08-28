Feature: AMF authentication with 5G-AKA

  Scenario: Authentication Initiation Request
    Given target type is AUSF_HTTP
    Given path is /nausf-auth/v1/ue-authentications
    Given request header is Content-Type:application/json
    Given request content is
      """
      {
      "supiOrSuci":"imsi-<imsi>",
      "servingNetworkName":"5G:mnc222.mcc111.3gppnetwork.org"
      }
      """
    When we send POST request
    Then we expect response status code 201
    Then we expect response time less than 1100 milliseconds
    Then we expect response content text property authType equals EAP_AKA_PRIME
    Then extract path from URI in response content property _links.eap-session.href and save as authCtxId    
    Then compute eapPayload using EAP-AKA-PRIME algorithm


  Scenario: Authentication Confirmation
    Given target type is AUSF_HTTP
    Given path is <authCtxId>
    Given request header is Content-Type:application/json
    Given request content is
      """
      {
      "eapPayload":"<eapPayload>"
      }
      """
    When we send POST request
    Then we expect response status code 200
    Then we expect response content text property authResult equals AUTHENTICATION_SUCCESS
    Then we expect response time less than 1100 milliseconds
