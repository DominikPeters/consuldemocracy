# Vagrant

Instale [Vagrant](https://www.vagrantup.com/) y configure una máquina virtual con [Linux](prerequisites.md)

Vagrant es compatible para [Debian](debian.md) y [Ubuntu](ubuntu.md).

## Browser configuration

Para acceder a la aplicación a través del navegador en la url `localhost:3000` debe enrutar el puerto de la aplicación y ejectuar el servidor de la aplicación con la opción `-b`:

## Enrutar el puerto de la aplicación

Abra el archivo de configuración de Vagrant:

```bash
nano Vagranfile
```

Encuentre esta línea:

```ruby
# config.vm.network "forwarded_port", guest: 80, host: 8080
```

Cámbiela por esta:

```ruby
config.vm.network "forwarded_port", guest: 3000, host: 3000
```

Recargue la máquina virtual:

```bash
vagrant reload
```

## Ejecutar el servidor

En su máquina virtual, debe ejecutar la aplicación enlanzándola a su IP local:

```bash
bin/rails s -b 0.0.0.0
```

Ahora debería ver la aplicación desde el navegardor en la url `localhost:3000` :tada:
