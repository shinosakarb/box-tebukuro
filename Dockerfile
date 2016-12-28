FROM ubuntu:16.10

RUN apt-get update
RUN apt-get install vim curl wget git apt-transport-https make -y

# Install the dependencies required for rbenv and ruby
RUN apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev -y

# Install rbenv
ENV RBENV_ROOT /root/.rbenv
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
RUN git clone https://github.com/sstephenson/ruby-build.git $RBENV_ROOT/plugins/ruby-build
RUN $RBENV_ROOT/plugins/ruby-build/install.sh
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH

ENV CONFIGURE_OPTS --disable-install-doc

# Install multipule ruby
ADD ./ruby_versions /root/ruby_versions
RUN xargs -L 1 rbenv install < /root/ruby_versions

# Install bundler
RUN echo 'gem: -N' >> /.gemrc
RUN bash -l -c 'for v in $(cat /root/ruby_versions); do rbenv global $v; rbenv version; gem install bundler; done'

# Install n
RUN curl -L https://git.io/n-install | bash -s -- -y
ENV N_PREFIX /root/n
ENV PATH $N_PREFIX/bin:$PATH

# Install multipule node.js
ADD ./node_versions /root/node_versions
RUN xargs -L 1 n < /root/node_versions

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y
