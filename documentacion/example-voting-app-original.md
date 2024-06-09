# Example Voting App

Una aplicación distribuida simple que se ejecuta en múltiples contenedores Docker.

## Empezamos

Descarga [Docker Desktop](https://www.docker.com/products/docker-desktop) para Mac o Windows. [Docker Compose](https://docs.docker.com/compose) se instalará automáticamente. En Linux, asegúrese de tener la última versión de [Compose](https://docs.docker.com/compose/install/).

Esta solución utiliza Python, Node.js, .NET, con Redis para mensajería y Postgres para almacenamiento.

Ejecute en este directorio para compilar y ejecutar la aplicación:

```shell
docker compose up
```

La app `vote` estará corriendo en [http://localhost:5000](http://localhost:5000), y el `results` estará en [http://localhost:5001](http://localhost:5001).

Alternativamente, si quieres ejecutarlo en un [Docker Swarm](https://docs.docker.com/engine/swarm/), Primero asegúrate de tener un swarm. Si no lo tienes, ejecuta:

```shell
docker swarm init
```

Una vez tengas tu swarm, corren en este directorio:

```shell
docker stack deploy --compose-file docker-stack.yml vote
```

## Ejecute la aplicación en Kubernetes

La carpeta `k8s-specifications` contiene las especificaciones YAML de los servicios de la aplicación de votación.

Ejecute el siguiente comando para crear las implementaciones y los servicios. Tenga en cuenta que creará estos recursos en su espacio de nombres actual (`default` si no lo ha cambiado).

```shell
kubectl create -f k8s-specifications/
```

La web app `vote` estará disponible en el puerto 31000 en cada host del clúster, la web app `result` estará disponible en el puerto 31001.

Para eliminarlos, ejecuta:

```shell
kubectl delete -f k8s-specifications/
```

## Arquitectura

![Architecture diagram](./sources/architecture.excalidraw.png)

* Una aplicación web front-end en [Python](../vote/) que te permite votar entre dos opciones.
* Un [Redis](https://hub.docker.com/_/redis/) que recoge nuevos votos.
* Un [.NET](../worker/) trabajador que consume votos y los almacena en...
* Un [Postgres](https://hub.docker.com/_/postgres/) base de datos alojada en un volumen Docker.
* Una aplicación [Node.js](../result/) que muestra los resultados de la votación en tiempo real.

## Notes

La aplicación de votación sólo acepta un voto por navegador del cliente. No registra votos adicionales si ya se ha enviado un voto de un cliente.

Este no es un ejemplo de una aplicación distribuida perfectamente diseñada y con una arquitectura adecuada... es solo un ejemplo simple de los diversos tipos de piezas y lenguajes que podrías ver (colas, datos persistentes, etc.) y cómo manejarlos con un nivel básico de Docker.
