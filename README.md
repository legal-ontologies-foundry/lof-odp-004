# LOF-ODP-004: Minimum Legal Chain

Draft ontology design pattern for the [Legal Ontologies Foundry](https://legal-ontologies-foundry.github.io/odp/odp-004/).
Status: **draft 0.1.0**, for review by the founding coordinators.

Connects the classes of LOF-ODP-001 to 003 into the chain through which a
particular legal position comes to exist (authority, norm, actor in role,
trigger, act, target, effect, remedy), and defines a class for positions whose
chain is complete. SHACL shapes report incomplete chains node by node.

## Layout

| Path | Contents |
|---|---|
| `lof-odp-004.owl`, `lof-odp-004-base.owl` | Release files (RDF/XML), at the repo root where the w3id redirects expect them |
| `src/ontology/odp-004-edit.ttl` | Editors' file |
| `src/ontology/imports/` | BFO 2020 core; **local stubs** of ODP-001 to 003 |
| `src/ontology/alternatives/` | ODP-003 Option B stub |
| `src/ontology/catalog-*.xml` | Import resolution for build and tests |
| `src/examples/lease-chain.ttl` | Worked example, including one defective chain |
| `src/shapes/mlc-closure.shacl.ttl` | Node-by-node chain-closure shapes |
| `src/sparql/` | Competency-question queries |

## Stubs

The ODP-001 to 003 files in `src/ontology/imports/` were reconstructed from
the published specification pages, because the pattern repositories were not
yet reachable when this draft was built. Their IRIs follow the published
pages exactly. Once `lof-odp-001` to `003` are released, point the catalogs at
the released files and delete the stubs.

## Tests (verified on the 0.1.0 draft)

- `make test-options`: HermiT, both ODP-003 options. Consistent, no
  unsatisfiable classes, identical classifications.
- `make shacl`: the lease chain conforms; the side-promise chain fails at
  nodes 1, 4, 5 and 8; the late-fee claim warns at node 3 (operation of law).
- `make release`: ROBOT report, no ERRORs.

ID range: 0001000 to 0001999 (first editor, D. R. Koepsell).
License: CC BY 4.0.
