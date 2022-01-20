# Modulo de Parámetros

En este modulo se cuenta con las definiciones asociadas a los parámetros y variables requeridas para la ejecución de las plantillas terraform del proyecto.

### Control de Cambios

| Versión | Fecha | Responsable | Comentarios |
|--|--|--|--|
| Versión actual (v.1.0.0) | Agosto 21, 2021| [Jeisson Osorio]() |   Versión Inicial |

## Tabla de Contenido
- [Modulo de Parámetros](#modulo-de-parámetros)
    - [Control de Cambios](#control-de-cambios)
  - [Tabla de Contenido](#tabla-de-contenido)
  - [Pre-requisitos](#pre-requisitos)
    - [Uso de Workspace Terraform](#uso-de-workspace-terraform)

## Pre-requisitos

### Uso de Workspace Terraform

Este modulo retorna los valores de cada uno de los parámetros dependiendo del workspace terraform utilizado para su ejecución.

En la definición de las variables de contexto del locals se pueden definir tantos arreglos como workspaces se requieran trabajar de acuerdo a la siguiente estructura:

```js
locals {
  context_variables = {
    dev = { variables dev ...}
    qa  = { varaibles qa ...}
    pd  = { varaibles pd ...}
```

Una vez definidos estos arreglos de variables, en la asignación de los parámetros se realiza un lookup del workspace en el cual se esta ejecutando la plantilla(terraform.workspace), motivo por el cual si el workspace no se encuentra definido, no sera posible realizar la asignación de los parámetros.

Ejemplo:
```js
  environment = lookup( local.context_variables[terraform.workspace] , "environment" , "dev" )
```
