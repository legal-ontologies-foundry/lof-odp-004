# LOF-ODP-004 build and test. Requires Java, ROBOT (robot.jar), and pyshacl.
ROBOT ?= java -jar robot.jar
ONT = src/ontology
EX  = src/examples/lease-chain.ttl

.PHONY: test test-options shacl cq release
test: test-options shacl cq

# LOF-P-011: consistent, no unsatisfiable classes, under both ODP-003 options
test-options:
	$(ROBOT) merge --catalog $(ONT)/catalog-examples.xml -i $(EX) \
	  reason --reasoner HermiT --axiom-generators "ClassAssertion PropertyAssertion" --include-indirect true \
	  -o $(ONT)/tmp/example-reasoned-A.ttl
	$(ROBOT) merge --catalog $(ONT)/catalog-examples-option-b.xml -i $(EX) \
	  reason --reasoner HermiT --axiom-generators "ClassAssertion PropertyAssertion" --include-indirect true \
	  -o $(ONT)/tmp/example-reasoned-B.ttl

# Chain-closure report (the example deliberately contains one defective chain)
shacl: test-options
	-pyshacl -s src/shapes/mlc-closure.shacl.ttl -df turtle $(ONT)/tmp/example-reasoned-A.ttl
	-pyshacl -s src/shapes/mlc-closure.shacl.ttl -df turtle $(ONT)/tmp/example-reasoned-B.ttl

# Competency questions
cq: test-options
	for q in src/sparql/*.rq; do $(ROBOT) query -i $(ONT)/tmp/example-reasoned-A.ttl --query $$q $(ONT)/tmp/$$(basename $$q .rq).tsv; done

release:
	$(ROBOT) merge --catalog $(ONT)/catalog-v001.xml -i $(ONT)/odp-004-edit.ttl \
	  reason --reasoner HermiT --equivalent-classes-allowed asserted-only report --fail-on ERROR
	$(ROBOT) convert -i $(ONT)/odp-004-edit.ttl -o lof-odp-004.owl && cp lof-odp-004.owl lof-odp-004-base.owl
