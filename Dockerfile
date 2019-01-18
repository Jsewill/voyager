FROM alpine

RUN apk add --update --no-cache npm git python make gcc g++ cairo-dev libjpeg-turbo-dev pango-dev giflib-dev



RUN git clone https://github.com/vega/voyager.git

# Install yarn using npm, due to https://github.com/yarnpkg/yarn/issues/2821
RUN npm install -g yarn \
	&& cd /voyager \
	&& yarn \
	&& yarn build

RUN yarn cache clean \
  	&& rm -rf /tmp/* \
  	&& rm -rf ~/.m2 ~/.npm ~/.cache \
  	&& rm -rf /var/lib/{apt,dpkg,cache,log}/

# Adjust scripts to expose this service to external hosts/nodes
RUN sed -i "s/devServer: {/devServer: {\n    host: '0.0.0.0',/" /voyager/config/webpack.config.dev.js
RUN sed -i "s/devServer: {/devServer: {\n    host: '0.0.0.0',/" /voyager/config/webpack.config.lib.js

# @TODO: remove unnecessary files after yarn build

WORKDIR /voyager

EXPOSE 9000

CMD ["yarn", "start"]	
