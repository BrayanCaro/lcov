FROM perl:5.40 AS perl-base

ENV LCOV_VERSION="v2.3"

RUN cpanm -nq \
    Capture::Tiny \
    DateTime \
    Date::Parse

RUN git clone https://github.com/linux-test-project/lcov.git /tmp/lcov \
    && cd /tmp/lcov \
    && git checkout $LCOV_VERSION \
    && make install \
    && rm -rf /tmp/lcov

FROM perl:5.40-slim

COPY --from=perl-base /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=perl-base /usr/local/lib/lcov /usr/local/lib/lcov

COPY --from=perl-base /usr/local/bin/genhtml /usr/local/bin/lcov /usr/local/bin/

