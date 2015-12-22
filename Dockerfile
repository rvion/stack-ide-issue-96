FROM debian

# Install curl, git and stack/stack-ide dependencies
# I just guessed the dependencies from the error messages of my `stack build`
# I don't know if those are documented anywhere?
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libgmp-dev \
    xz-utils \
    zlib1g-dev

# Install stack
RUN curl -L https://www.stackage.org/stack/linux-x86_64 > /tmp/stack.tar.gz
RUN tar xf /tmp/stack.tar.gz -C /tmp/ --strip-component 1
RUN chmod +x /tmp/stack
RUN mv /tmp/stack /usr/local/bin/stack

# Should be the latest release I guess ?
RUN stack --version
# Should be a x86_64 Linux
RUN uname -a

# Install stack ide
RUN git clone https://github.com/commercialhaskell/stack-ide.git
WORKDIR /stack-ide
RUN git submodule update --init --recursive
# It's apparently necessary to `stack setup` beforehand
# (not documented but I guess it's stack related knowledge)
RUN stack setup
RUN stack build --dependencies-only
CMD stack build -v --copy-bins
