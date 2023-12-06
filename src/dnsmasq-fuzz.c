#include "dnsmasq.h"
#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION

__AFL_FUZZ_INIT();

static unsigned char *buf;
int len;

ssize_t fuzz_recvmsg(struct msghdr *msg) {

    struct iovec *iov = msg->msg_iov;
    memcpy(iov->iov_base, buf, len);
    return len;
}

int main (int argc, char **argv) {
    buf = __AFL_FUZZ_TESTCASE_BUF;

    dnsmasq_main(argc, argv);

    while (__AFL_LOOP(10000)) {
        len = __AFL_FUZZ_TESTCASE_LEN;

        if (len < (int)sizeof(struct dns_header)) continue;
        if (len > daemon->edns_pktsz) continue;

        time_t now = dnsmasq_time();
        struct listener listeny = { 0 };

        receive_query(&listeny, now);
    }

  return 0;
}

#endif