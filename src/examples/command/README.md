# Worked example 2: change of command

Encodes W. Mandrick's "Change (Assumption) of Command" use case (3rd Infantry
Battalion, 15 June 2026) against LOF-ODP-001 to 004. Hypothetical officers.
Run with `make command` from `src/ontology`.

## Results (verified under both ODP-003 options)

**The patterns cover the case without new terms.** HermiT infers:

- the assumption process is a *role conferral act*, and the relinquishment a
  *role termination act* (ODP-002);
- Smith's commander role is a *conferred legal role*;
- the powers of Congress, the Secretary of the Army, and the order's issuer
  are each a *norm-establishing power* (ODP-004 node 1);
- 15 June 2026 1000hrs is a *triggering occurrence*;
- Smith's duty to maintain readiness is a *fully grounded legal position*,
  directed at the Department of the Army (inferred, not asserted).

The chain-closure shapes report no breaks. Competency question 4
(`sparql/cq4-authority-regress.rq`) recovers the full legal basis from slide 2,
from the assumption order through AR 600-20 and Title 10 to Art. I, sec. 8, by
repeating ODP-004's authority link at each level.

## Three findings for the coordinators

**1. One commander role cannot pass from Jones to Smith.** The original slides
give Jones's lost role and Smith's gained role the same identifier (#001).
BFO forbids this: a role has one bearer and cannot migrate. This example uses
two roles, #001 (Jones, terminated) and #002 (Smith, conferred).
`test-one-role-two-bearers.ttl` restores the single-role model: with BFO 2020
as published it is **consistent**, because BFO's OWL file does not encode the
one-bearer rule. With `proposal-functional-inherence.ttl`, which declares
'inheres in' functional as ISO 21838-2 requires, it is **inconsistent**, and
the reasoner's explanation names the role and its two bearers. The corrected
example stays consistent. **Adopted in ODP-002 0.2.0:** a legal role now has exactly one bearer.

**2. What persists is the position (ODP-002 open question 1).** Here the
position is modeled as the legal content of the MTOE authorization line, and
both commanders' roles are *specified by* it. That needs no new terms; whether
it is the right category is the open question.

**3. Does command authority pass, or is it re-created? (ODP-003 placement.)**
`test-command-passes.ttl` asserts that Jones's authority to issue lawful
orders is now held by Smith. Option A: **inconsistent** (Smith's authority is
a new power). Option B: **consistent** (the same power persists). Same result
as the lease-assignment test, in public law. **Resolved in ODP-003 0.2.0:**
positions are roles, and `test-command-succeeds.ttl` records that Smith's
authority *succeeds* Jones's. Consistent.

## To confirm (Bill)

- Which act confers the role: the assumption process under the order (as
  modeled), or the issuance of the order itself?
- Who holds the power to issue the assumption order: the incoming commander
  or a superior? (Modeled as a placeholder "issuer".)
- Relations on the original slides without a counterpart yet: *role within*,
  *commands / directs*. Their sources (CCO or other) should be stated.
