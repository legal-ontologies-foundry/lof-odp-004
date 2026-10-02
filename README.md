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
| `src/shapes/mlc-closure.shacl.ttl` | Node-by-node chain-closure shapes |
| `src/sparql/` | QC checks (`*-violation.sparql`) and competency questions (`cq*.rq`) |

## Building and testing

```
cd src/ontology
make test           # HermiT consistency + seven SPARQL QC checks + ROBOT report
make test-options   # worked example under both ODP-003 options
make shacl          # chain-closure report (needs: pip install pyshacl)
make cq             # competency questions
make release VERSION=0.1.0
```

Verified on 0.1.0: consistent under both ODP-003 options with identical
classifications; the lease chain conforms; the side-promise chain fails at
nodes 1, 4, 5 and 8; the late-fee claim warns at node 3 (operation of law).

## License

[CC BY 4.0](LICENSE). Term ID range ODP004_0001000 to 0001999 (first editor).
