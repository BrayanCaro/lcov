FROM perl:5.40 AS perl-base

ARG LCOV_VERSION

RUN cpanm -nq \
    Capture::Tiny \
    Date::Parse \
    DateTime

RUN git clone --depth 1 --branch $LCOV_VERSION https://github.com/linux-test-project/lcov.git /tmp/lcov \
    && make -C /tmp/lcov install \
    && rm -rf /tmp/lcov

FROM perl:5.40-slim

COPY --from=perl-base /usr/local/lib/perl5 /usr/local/lib/perl5
COPY --from=perl-base /usr/local/lib/lcov /usr/local/lib/lcov
COPY --from=perl-base /usr/local/bin/genhtml /usr/local/bin/lcov /usr/local/bin/
