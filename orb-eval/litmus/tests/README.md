# Ordering shapes

Twelve classic ordering shapes, written as C11 litmus tests for this project:
message passing (MP), store buffering (SB), load buffering (LB), write-to-read
causality (WRC), ISA2, 2+2W and read-read coherence (CoRR), each with relaxed
and with release-acquire or sequentially consistent accesses. The same shapes,
in their ARMv8 form, are in herdtools7's `catalogue/aarch64`.

They are part of every run (`../generate_all.sh`). The reference answer for
each one is computed by herd7 with `rc11.cat`, like for every catalogue test,
so the expected RC11 verdict is not written down anywhere by hand.

Unlike most catalogue tests, every shape whose outcome RC11 forbids depends on
the synthesized synchronization (see `../negative_control.sh`), except `CoRR`:
ARMv8's coherence guarantees it without any ordering instruction.

A thread returns at most one register to the generated test (in `W0`), so a
thread observing two loads stores them to `obs0`/`obs1` and the condition
names those locations instead.
