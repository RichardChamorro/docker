#!/bin/bash

# Definir variables de entorno
RAMA="capacitaciones"
REPOSITORIO="https://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@github.com/Israelgarate/BCE_01.git"
REPO_DOCKER="https://github.com/mbelengonzalez168/docker"
TAG="@Regresion"
NAV="Chrome"
NOMBRE_APELLIDO="belen_gonzalez"
TAG_IMAGEN="latest"

# Limpiar el espacio de trabajo
cleanWs

# Clonar el repositorio de Docker
git clone -b main $REPO_DOCKER $WORKSPACE

# Construir la imagen Docker
docker buildx build -t $NOMBRE_APELLIDO:$TAG_IMAGEN .

# Dar permisos de ejecución a los scripts en el directorio 'app'
chmod +x $WORKSPACE/app/*

# Ejecutar el script de clonación
sh clone.sh $RAMA $REPOSITORIO

# Ejecutar el contenedor Docker con las variables de entorno definidas
docker run -e RAMA=$RAMA -e REPOSITORIO=$REPOSITORIO -e TAG=$TAG -e NAV=$NAV $NOMBRE_APELLIDO:$TAG_IMAGEN

# Realizar análisis de eficiencia con DIVE
CI=true dive $NOMBRE_APELLIDO:$TAG_IMAGEN > log.txt
cat log.txt

# Realizar análisis de archivo Dockerfile con HADOLINT
docker run --rm -i hadolint/hadolint:latest < Dockerfile > logfile.txt || true
cat logfile.txt

# Realizar análisis de vulnerabilidades con TRIVY
trivy image $NOMBRE_APELLIDO:$TAG_IMAGEN > trivy.txt
cat trivy.txt

# Eliminar las imágenes Docker utilizadas
docker rmi -f $NOMBRE_APELLIDO:$TAG_IMAGEN
docker rmi -f hadolint/hadolint