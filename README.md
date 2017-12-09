# README
I have some things to say... 
The AWS instances that we have available are horrible. They keep running out of memory and failing randomly.
For some reason I keep losing access to my Jenkins instance. I've made sure that they're not killing me for pushing my .pem files on github, blocking my .pem. I was doing that accidentally... for a bit... but that's definitely not the current problem. 
I can't ssh, I can't ping. It's like the instance doesn't exist anymore, even if it shows as running on AWS console. 
I really don't know what to do. 
I've set up Jenkins a total of 7 times now... 
That and the problems with memory and the bad scripts we've been given, has taken so much time from us that there is no time for the unit testing phase. 
The project that we were given was supposed to be more or less ready for deployment, yet I've spent the better part of this week just to try to deploy it through Jenkins. (it deploys locally)
I think most of us have been struggling with this for days now without much progress. Just knocking our heads against a wall for hours and hours. 
The few that have actually managed to do this really can't tell us how... Because they don't know.






## Application for HGOP 2017 Student project

Global installation requirements:


nodejs version 6.9.1
https://nodejs.org/en/

It is recommended to install nvm (node version manager) to install node and choose which version you use. 

optional: yarn for package management (server only). 
https://yarnpkg.com/

Add ./node_modules/.bin to your path. This enables to you to run locally installed npm commands.

nodemon for watching server and restarting on modifications.
```
npm install -g nodemon
```


For developing React single-page-app (optional):

```
npm install -g create-react-app
```


## Getting started:

Install and run postgres docker image for development.
```
npm run startpostgres && npm run migratedb
```

In project root directory, install NPM dependencies:

```
yarn install (or npm install)

```

Start API server.
```
npm run startserver
```

To run server side tests in watch mode (in another terminal window):
```
npm run test
```
This runs server-side jasmine tests, which are then automatically rerun when a file is saved.


In another terminal window, run the React web client. Do **NOT** use yarn install here, it is not
compatible with this project.
```
cd client
npm install
npm run start
```

At this point you should see the HGOP intro page open in your browser.
If not, you should be able to point your browser to http://localhost:3000 and open it.

To run client tests in watch mode:
```
cd client
npm run test
```
On linux, this may fail due to too many watches being created. To fix, issue this command:

```
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```



To run API tests, simulating client calls to server socket-io api. API server must be running.

```
npm run apitest
```


To run API load tests, simulating client load on server socket-io api. API server must be running.

```
npm run loadtest
```


To build and deploy new version in a new ec2 instance on amazon:

```
./dockerbuild.sh

export GIT_COMMIT= <git hash used to tag your container>

cd provision
./provision-new-environment.sh
```


## Development

When developing this project, I like haveing a few open terminals
- One in root, running the autorestarting API server:
```
cd .
npm run startserver
```

- One in client, running the auto-restarting web client:
```
cd ./client
npm run start
```
- One to run tests and other commands you need at any given moment, such as npm/yarn install, running
one of the other commands above.



## Build targets

```
npm run build
```
This builds both server and client, and combines in a single server to
run in a production-like setting, such as within a docker image.

```
npm run clean
```
Clean generated artifacts in build directories.

```
npm run startpostgres
```
Launch or restart a local postgres instance. Required for running the application, api tests and load tests.



## Notes

The main emphasis in this sample application is on object decomposition and testability, achieved with fine-grained
objects wired together with aggressive use of dependency injection. The architecture style used is fully message based
using Command Query Responsibility Segregation (CQRS) with event sourcing. This is an appropriate architecture for
many classes of applications, such as where synchronizing views of multiple users is an important concern, and where
achieving near-linear scaling of servers in clustered environments is a concern.

Notice especially that use of import/require statements are limited to application context
objects and to test files. Application context objects are there to wire the application
together, and should generally not contain any conditional logic.

Due to this architecture, it is relatively simple to reuse logic between server and
client, which is generally a hard problem to solve cleanly. Code that is shared
between client and server is found on the [client](client/src) side. routing-context is a good example,
since it is used both in the web client, and in the API and load tests.

Note that transaction support, error handling and logging are incomplete, and many other details that would be 
required in production-ready clustered applications are not present.






## Links

http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-launch.html
