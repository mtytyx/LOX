#!/bin/bash

# Detén y elimina cualquier contenedor relacionado con Playit
containers=$(docker ps -aq --filter "name=playit")
if [ -n "$containers" ]; then
  docker stop $containers
  docker rm $containers
else
  echo "No se encontraron contenedores de Playit."
fi

# Elimina las imágenes de Docker relacionadas con Playit
images=$(docker images | grep "playit" | awk '{print $3}')
if [ -n "$images" ]; then
  docker rmi $images
else
  echo "No se encontraron imágenes de Playit."
fi

# Borra los archivos y directorios asociados
find ~ -name "*playit*" -exec rm -rf {} +

# Revierte cualquier cambio en la configuración del sistema
sed -i '/playit/d' ~/.bashrc
sed -i '/playit/d' ~/.zshrc

# Elimina cualquier variable de entorno relacionada
unset PLAYIT_VAR

# Elimina los registros de Playit con permisos elevados
sudo find /var/log -name "*playit*" -exec rm -rf {} +

echo "Limpieza de Playit completada."
