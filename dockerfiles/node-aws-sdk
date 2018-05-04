FROM node:8-alpine

WORKDIR /aws
RUN npm -g install aws-sdk
RUN npm link aws-sdk

CMD ['echo', 'Done!']