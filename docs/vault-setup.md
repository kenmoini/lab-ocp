# Vault Setup

1. Deploy Vault
2. Unseal Vault
3. Log in via Web UI and the Root Token
4. Enable the KV Store Secrets Engine at kv/
5. Enable the User/Pass Authentication engine
6. Add a user called `openshift`
7. Create a Policy called `kv_reader` to read secrets

```
path "/kv/*" {
  capabilities = ["read"]
}
```

8. Create a Policy called `kv_browser` to read secrets

```
path "/kv/*" {
  capabilities = ["read", "list"]
}
```

8. Run a command in the Vault UI Shell to associate the policy to the user

```
write auth/userpass/users/openshift policies=kv_reader
```

9. Create a Secret called `bootstrap-vault-userpass` in the `kube-system` namespace, with the key of `password`.  The ESO ACM Policy will copy it where it needs to be on the Hub and other Managed Clusters that have ESO enabled.