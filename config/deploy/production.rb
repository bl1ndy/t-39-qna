server '185.235.130.81', user: 'deploy', roles: %w{app db web}, primary: true

set :ssh_options, {
 keys: %w(/home/deploy/.ssh/id_ed25519.pub),
 forward_agent: true,
 auth_methods: %w(publickey password),
 port: 2222
}
