FROM debian:jessie
MAINTAINER Vijay Korapaty <mediagoblin@korapaty.com>

# Required pacakges
# Doing all of this as a single step for caching during image build.
RUN apt-get update && \
    apt-get install -y \
    # Base requirements
    sudo git-core python-virtualenv \
    # Python 3 requirements
    python3 python3-dev \
    libpython3-dev \
    python3-lxml python3-pil \
    # Video and audio requirements
    python-gi python3-gi \
    gstreamer1.0-tools \
    gir1.2-gstreamer-1.0 \
    gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \
    python-gst-1.0 \
    python3-gst-1.0 \
    # Additional audio requirements
    libasound2-dev python3-numpy python3-scipy \
    libsndfile1-dev libsndfile-dev

# Postgres
RUN apt-get update \
    && apt-get install -y postgresql postgresql-client python3-psycopg2

RUN apt-get update && apt-get upgrade -y

# Drop Privileges for MediaGoblin
RUN useradd -c "GNU MediaGoblin system account" -d /var/lib/mediagoblin \
    -m -r -g www-data mediagoblin
RUN groupadd mediagoblin
RUN usermod --append -G mediagoblin mediagoblin

# MediaGoblin code and setup
RUN mkdir -p /srv/mediagoblin
WORKDIR /srv/mediagoblin
RUN git clone git://git.savannah.gnu.org/mediagoblin.git -b stable --depth 1
RUN chown -hR mediagoblin:www-data /srv/mediagoblin
WORKDIR /srv/mediagoblin/mediagoblin
RUN git submodule init && git submodule update
RUN (virtualenv --system-site-packages -p python3 . || virtualenv -p python3 .) \
    && ./bin/python setup.py develop --upgrade

## For spectrograms of audio
#RUN ./bin/pip install scikits.audiolab

ADD mediagoblin_local.ini /srv/mediagoblin/mediagoblin/mediagoblin.ini
ADD entrypoint.sh /srv/mediagoblin/mediagoblin/entrypoint.sh

EXPOSE 6543

ENTRYPOINT ["/srv/mediagoblin/mediagoblin/entrypoint.sh"]
CMD ["/bin/bash"]
