FROM alpine

RUN apk add nodejs nodejs-npm

COPY littleserver.js .

EXPOSE 1234

CMD ["node", "littleserver.js"]