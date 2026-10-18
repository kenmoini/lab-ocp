# Automation Orchestrator Setup

> No CaC collection, manual stuff


## Identity Providers

- Provider Name: `OpenShellOIDC`
- Enable Provider: `true`
- Issuer URL: https://openshell-sso.apps.tri-force.lab.kemo.network/realms/openshell
- Client ID: `aap`
- Client Secret: `duh`
- Disable TLS certificate verification: `true`
- Scopes: `openid` `profile` `email` `roles`
- Claim Mapping:
  - Subject Claim: `sub`
  - Email Claim: `email`
  - Username Claim: `email`
  - First name Claim: `given_name`
  - Last name Claim: `family_name`
  - Groups extraction expression: `realm_roles[*]`

**With the IdP created, map the groups**

## Projects

- Create a project: `openshell`

## Credentials

- Create an AAP type credential, use Basic Auth for simplicity

## Integrations

- Name: `HubAAP`
- Integration Type: `Ansible Automation Platform`
- URL: `https://hub-aap.apps.tri-force.lab.kemo.network`
- Connection credential: `hub-aap`
- TLS certificate verification: `false`