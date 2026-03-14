<p align="center"><img src="https://s3.amazonaws.com/larasail/logo.svg" width="300"></p>

# LaraSail

LaraSail is a CLI tool for Laravel to help you sail the servers of the [DigitalOcean](https://digitalocean.com/).

<p align="center"><img src="https://s3.amazonaws.com/larasail/larasail-command.png"></p>

---

You'll need a DigitalOcean account before getting started ([Signup here](https://m.do.co/c/6e2fb7e2925f)), then you'll need to create a `New Droplet`. Make sure to select **Ubuntu 24.04**:

<p align="center"><img src="https://user-images.githubusercontent.com/21223421/194825321-c91e059f-a862-481e-a928-4f9d7ebce08e.png"></p>

## Installation

SSH into your server and run the following command:

```
curl -sL https://github.com/RomanNebesnuyGC/larasail/archive/master.tar.gz | tar xz && source larasail-master/install
```

You can make sure it's installed and check the version by running:

```
larasail version
```

## Setup your server

```
larasail setup
```

The default configuration installs **Nginx**, **PHP 8.5**, **MariaDB 11.8 LTS**, and **Redis**. You can combine flags freely — order doesn't matter:

```
larasail setup php84           # PHP 8.4, MariaDB 11.8, Redis
larasail setup php83           # PHP 8.3, MariaDB 11.8, Redis
larasail setup php81           # PHP 8.1, MariaDB 11.8, Redis
larasail setup php80           # PHP 8.0, MariaDB 11.8, Redis
larasail setup php74           # PHP 7.4, MariaDB 11.8, Redis
```

### Database

By default, LaraSail installs **MariaDB 11.8 LTS**. To use MySQL or PostgreSQL instead:

```
larasail setup mysql           # PHP 8.5, MySQL 8, Redis
larasail setup pgsql           # PHP 8.5, PostgreSQL, Redis
larasail setup mysql php84     # PHP 8.4, MySQL 8, Redis
larasail setup pgsql php84     # PHP 8.4, PostgreSQL, Redis
```

### Redis

Redis is installed by default with every `larasail setup` — no extra flag needed.

## Creating a new site

### :sparkles: Automatically

#### Laravel

After setting up the server you can create a new project by running:

```
larasail new <project-name> [--jet <livewire|inertia>] [--teams] [--www-alias]
```

This will automatically create a project folder in `/var/www` and set up a host if the provided project name contains periods (they will be replaced with underscores for the directory name). By default, LaraSail sets up the Nginx site configuration and [Let's Encrypt](https://letsencrypt.org/) SSL certificate for your domain. If you would like both the `www` alias and root domain setup (i.e. `example.com` and `www.example.com`) kindly pass the `--www-alias` flag.

#### Wave

[Wave](https://github.com/thedevdojo/wave) - The Software as a Service Starter Kit, designed to help you build the SAAS of your dreams. :rocket: :moneybag:
LaraSail allows you to create a new Wave project automatically by adding `--wave` flag to the `new` command as follows:

```
larasail new <project-name> [--wave]
```

Just like Laravel above, this will create a project folder, setup the Nginx site configuration and Let's Encrypt SSL certificate for your domain. By default, you will be prompted to create a project database and if successful, will migrate and seed the database.

### :construction: Manually

Alternatively, you can clone a repository or create a new Laravel app within the `/var/www` folder:

```
cd /var/www && laravel new mywebsite
```

Then, you'll need to setup a new Nginx host by running:

```
larasail host mywebsite.com /var/www/mywebsite --www-alias
```

`larasail host` accepts three parameters:

1. Your website domain *(mywebsite.com)*
2. The location of the files for your site *(/var/www/mywebsite)*
3. Optional flag to also include the `www` alias: `www.mywebsite.com` *(--www-alias)*

Finally, point your domain to the IP address of your new server. And wallah, you're ready to rock 🤘 with your new Laravel website. If you used the `--www-alias` flag, don't forget to add your domain's www `CNAME` record.

## Managing Nginx Hosts

List all configured virtual hosts:

```
larasail hosts list
```

## Passwords

When installing and setting up LaraSail there are two passwords that are randomly generated:

1. The password for the `larasail` user created
2. The default database admin password

To get the `larasail` user password:

```
larasail pass
```

To get the database admin password:

```
larasail mysqlpass
```

## Creating a database

After you have created your project you can create a database and user for it by using the following command:

```
larasail database init [--user larasail] [--db larasail] [--force]
```

By default it will create a database and the user `larasail` and grant all permissions to that user.

**TIP**: If you are in the project directory when you run this command, it will also try to update the `.env` file with the newly generated credentials.

To list all databases:

```
larasail database list
```

To show stored database passwords:

```
larasail database pass
```

## Switching to the larasail user

When you SSH into your server you may want to switch users back to the `larasail` user, you can do so with the following command:

```
su - larasail
```

## Updating LaraSail

To update LaraSail to the latest version:

```
larasail update
```

Make sure to star this repository and watch it for future updates. Thanks for checking out LaraSail. ⛵

## Contributing

If you are contributing, please read the [contributing file](CONTRIBUTING.md) before submitting your pull requests.
