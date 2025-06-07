# Getting Started Todo App

This project provides a sample todo list application. It demonstrates all of
the current Docker best practices, ranging from the Compose file, to the
Dockerfile, to CI (using GitHub Actions), and running tests. It's intended to 
be a well-documented to ensure anyone can come in and easily learn.

This sample application is a simple React frontend that receives data from a
Node.js backend. 


## Development

To spin up the project locally, install Docker Desktop and then run the following 
commands:

```
git clone https://github.com/docker/getting-started-todo-app
cd getting-started-todo-app
docker compose up -d
```



```
docker compose down
```
