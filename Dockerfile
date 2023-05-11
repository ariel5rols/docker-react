# we can tag this phase (as "tag")
# from that line on is all gonna be reffered to builder
# sole purpose of this phase is to install deps and build our app
FROM node:16-alpine as builder

WORKDIR '/app'
COPY package.json .
RUN npm install

# since we're doing a build phase, we dont have to
# make use of volumes with docker-compose, since the purpose of that
# was to make our changes to the app file reflect asap
# becasue this is production we're not changing our code anymore
COPY . .

RUN npm run build
# the build folder will be created inside the container /app/build
# thatll have all the stuff we care about that we'd copy during our run phase

# we dont have to tag, since we put a new FROM this is a new block
FROM nginx
# this is saying i want to copy something from that other phase
# on the nginx page on docker hub, it says the config to serve html content is this folder
                    # <dir to copy> <dest dir>
COPY --from=builder /app/build /usr/share/nginx/html

# THIS IS IT! we dont need to start it since the default command starts nginx for us