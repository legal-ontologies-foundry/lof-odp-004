# LOF-ODP-004: Minimum Legal Chain

Draft ontology design pattern for the [Legal Ontologies Foundry](https://legal-ontologies-foundry.github.io/odp/odp-004/).
Status: **draft 0.1.0**, for review by the founding coordinators.

Connects the classes of LOF-ODP-001 to 003 into the chain through which a
particular legal position comes to exist (authority, norm, actor in role,
trigger, act, target, effect, remedy), and defines a class for positions whose
chain is complete. SHACL shapes report incomplete chains node by node.

## Files

| Path | Contents |
|---|---|
| `lof-odp-004.owl`, `lof-odp-004-base.owl` | Full and base releases |
| `src/ontology/lof-odp-004-edit.ttl` | Editors' file |
| `src/ontology/imports/` | BFO 2020 core and the base releases of ODP-001 to 003 |
| `src/ontology/alternatives/` | ODP-003 Option B base, for testing under both placements |
| `src/examples/lease-chain.ttl` | Worked example, including one defective chain |
| `src/examples/command/` | Worked example 2: W. Mandrick's change-of-command case |
| `src/examples/legal-basis/` | Worked example 3: Article I, sec. 8 to 8 U.S.C. 1103(a)(3) to 8 C.F.R. 103.1 (issue #12) |
| `src/shapes/mlc-closure.shacl.ttl` | Node-by-node chain-closure shapes |
| `src/sparql/` | QC checks (`*-violation.sparql`) and competency questions (`cq*.rq`) |

## Building and testing

```
cd src/ontology
make test           # HermiT consistency + seven SPARQL QC checks + ROBOT report
make test-options   # worked example under both ODP-003 options
make shacl          # chain-closure report (needs: pip install pyshacl)
make cq             # competency questions
make release VERSION=0.2.0
make command       # change-of-command example and tests
make legal-basis   # legal basis and delegation example
```

Verified on 0.2.0 (unchanged from 0.1.0): consistent under both ODP-003 options with identical
classifications; the lease chain conforms; the side-promise chain fails at
nodes 1, 4, 5 and 8; the late-fee claim warns at node 3 (operation of law).

## Legal basis and delegation (0.2.0)

Following W. Mandrick (issue #12), three relations connect bodies of legal
content by authority. None is a new primitive: each is inferred from the chain
the pattern already records.

| Relation | Inferred from | Example |
|---|---|---|
| `legal basis for` | content grounds a power, exercised in an act, that establishes the other content | 8 U.S.C. 1103(a)(3) is the legal basis for 8 C.F.R. 103.1 |
| `derives authority from` (transitive) | one or more steps of *legal basis for*, inverted | 8 C.F.R. 103.1 derives authority from the statute and from Art. I, sec. 8 |
| `delegates legal authority to` | content grounds a *power* held by a person or organization | 8 U.S.C. 1103(a)(3) delegates legal authority to the Secretary |

The chain runs through the power exercised, not through ODP-001 *performed
under*, so procedural rules are not counted as a legal basis. Delegation is
restricted to powers: a duty grounded in the same statute is not a delegation
(tested in the example).

## License

[CC BY 4.0](LICENSE). Term ID range ODP004_0001000 to 0001999 (first editor).
