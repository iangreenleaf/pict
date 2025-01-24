On Dokku:
```
dokku apps:create pict
dokku storage:mount pict /var/lib/dokku/data/storage/pict/uploads:/app/priv/static/uploads
dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku postgres:create pict
dokku postgres:link pict pict
dokku config:set pict SECRET_KEY_BASE=my-app-secret
dokku buildpacks:add pict gigalixir/gigalixir-buildpack-elixir
```

Locally:
```
git remote add dokku dokku@dokku.mydomain.net:pict
git push dokku main
```

On Dokku:
```
dokku run pict mix ecto.migrate
dokku domains:set pict pict.mydomain.net
dokku domains:report pict
dokku config:set --no-restart pict PHX_HOST=pict.mydomain.net
dokku config:set --no-restart pict PHX_EMAIL_FROM=pict@mydomain.net
dokku config:set --no-restart pict DOKKU_LETSENCRYPT_EMAIL=myemail@example.com
dokku ps:restart pict
dokku letsencrypt:enable pict
dokku config:set --no-restart pict SMTP_RELAY=smtp.fastmail.com
dokku config:set --no-restart pict SMTP_USERNAME=me@fast-mail.org
dokku config:set --no-restart pict SMTP_PASSWORD=abcd
```
