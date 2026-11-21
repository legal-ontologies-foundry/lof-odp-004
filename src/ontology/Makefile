# LOF-ODP-004: Minimum Legal Chain: build, test, and release.
# Requires Java 11+ and make. ROBOT is downloaded on first use.
#   make test                   run all QC checks (LOF-P-011 and SPARQL checks)
#   make release VERSION=x.y.z  write the release files to the repo root

ID       := odp-004
NAME     := lof-odp-004
BASE     := https://w3id.org/lof
EDIT     := lof-odp-004-edit.ttl
CATALOG  := catalog-v001.xml
LOF_DEPS := odp-001 odp-002 odp-003
ROBOT_JAR := ../../bin/robot.jar
ROBOT    := java -jar $(ROBOT_JAR)
TMP      := tmp
VERSION  ?= 0.2.0

.PHONY: test reason verify report release clean
test: verify report

$(ROBOT_JAR):
	mkdir -p ../../bin && curl -sSL -o $@ https://github.com/ontodev/robot/releases/download/v1.9.7/robot.jar

$(TMP):
	mkdir -p $(TMP)

$(TMP)/merged.owl: $(EDIT) | $(ROBOT_JAR) $(TMP)
	$(ROBOT) merge --catalog $(CATALOG) --input $(EDIT) --output $@

# LOF-P-011: consistent, no unsatisfiable classes
$(TMP)/reasoned.owl: $(TMP)/merged.owl
	$(ROBOT) reason --reasoner HermiT --equivalent-classes-allowed asserted-only --input $< --output $@

reason: $(TMP)/reasoned.owl

# SPARQL checks on the reasoned ontology; any result fails the build
verify: $(TMP)/reasoned.owl
	$(ROBOT) verify --input $< --queries ../sparql/*-violation.sparql --output-dir $(TMP)

report: $(TMP)/merged.owl
	$(ROBOT) report --input $< --fail-on ERROR --output $(TMP)/report.tsv

# Base: this pattern's own axioms only. Full: merged with imports, reasoned.
release: test
	$(ROBOT) remove --input $(EDIT) --select imports --trim false \
	  annotate --ontology-iri $(BASE)/$(ID)/$(NAME)-base.owl \
	  --version-iri $(BASE)/$(ID)/releases/$(VERSION)/$(NAME)-base.owl \
	  --annotation owl:versionInfo $(VERSION) --output ../../$(NAME)-base.owl
	$(ROBOT) merge --catalog $(CATALOG) --input $(EDIT) \
	  reason --reasoner HermiT --equivalent-classes-allowed asserted-only \
	  annotate --ontology-iri $(BASE)/$(ID).owl \
	  --version-iri $(BASE)/$(ID)/releases/$(VERSION)/$(NAME).owl \
	  --annotation owl:versionInfo $(VERSION) --output ../../$(NAME).owl

clean:
	rm -rf $(TMP)

# ---------------------------------------------------------------- ODP-004 only
EX := ../examples/lease-chain.ttl
.PHONY: test-options shacl cq
# Reason over the worked example under both ODP-003 placement options
test-options: | $(ROBOT_JAR) $(TMP)
	$(ROBOT) merge --catalog catalog-examples.xml --input $(EX) reason --reasoner HermiT \
	  --axiom-generators "ClassAssertion PropertyAssertion" --include-indirect true --output $(TMP)/example-reasoned-A.ttl
	$(ROBOT) merge --catalog catalog-examples-option-b.xml --input $(EX) reason --reasoner HermiT \
	  --axiom-generators "ClassAssertion PropertyAssertion" --include-indirect true --output $(TMP)/example-reasoned-B.ttl
	@echo "Both ODP-003 options: consistent"
# Node-by-node chain-closure report (the example contains one defective chain on purpose)
shacl: test-options
	-pyshacl -s ../shapes/mlc-closure.shacl.ttl -df turtle $(TMP)/example-reasoned-A.ttl
	-pyshacl -s ../shapes/mlc-closure.shacl.ttl -df turtle $(TMP)/example-reasoned-B.ttl
# Competency questions
cq: test-options
	for q in ../sparql/cq*.rq; do $(ROBOT) query --input $(TMP)/example-reasoned-A.ttl --query $$q $(TMP)/$$(basename $$q .rq).tsv; done

# Worked example 2: change of command (both ODP-003 options, plus tests)
.PHONY: command
command: | $(ROBOT_JAR) $(TMP)
	@for opt in A B; do c=catalog-examples.xml; [ $$opt = B ] && c=catalog-examples-option-b.xml; \
	  $(ROBOT) merge --catalog $$c --input ../examples/command/change-of-command.ttl --output $(TMP)/cmd-$$opt.owl; \
	  $(ROBOT) reason --reasoner HermiT --input $(TMP)/cmd-$$opt.owl --output $(TMP)/cmd-$$opt-r.owl && echo "Option $$opt: example consistent"; \
	  $(ROBOT) merge --input $(TMP)/cmd-$$opt.owl --input ../examples/command/test-one-role-two-bearers.ttl \
	    --input ../examples/command/proposal-functional-inherence.ttl --output $(TMP)/t1-$$opt.owl; \
	  $(ROBOT) reason --reasoner HermiT --input $(TMP)/t1-$$opt.owl --output $(TMP)/x.owl 2>/dev/null \
	    && echo "  one role, two bearers (with proposal): consistent" || echo "  one role, two bearers (with proposal): INCONSISTENT"; \
	  $(ROBOT) merge --input $(TMP)/cmd-$$opt.owl --input ../examples/command/test-command-passes.ttl --output $(TMP)/t2-$$opt.owl; \
	  $(ROBOT) reason --reasoner HermiT --input $(TMP)/t2-$$opt.owl --output $(TMP)/x.owl 2>/dev/null \
	    && echo "  same command power passes: consistent" || echo "  same command power passes: INCONSISTENT"; \
	  $(ROBOT) merge --input $(TMP)/cmd-$$opt.owl --input ../examples/command/test-command-succeeds.ttl --output $(TMP)/t3-$$opt.owl; \
	  $(ROBOT) reason --reasoner HermiT --input $(TMP)/t3-$$opt.owl --output $(TMP)/x.owl 2>/dev/null \
	    && echo "  new command power succeeds the old: consistent" || echo "  new command power succeeds the old: INCONSISTENT"; \
	done

# Worked example 3: legal basis and delegation (issue #12)
.PHONY: legal-basis
legal-basis: | $(ROBOT_JAR) $(TMP)
	$(ROBOT) merge --catalog catalog-legal-basis.xml --input ../examples/legal-basis/legal-basis.ttl \
	  reason --reasoner HermiT --output $(TMP)/legal-basis-reasoned.owl && echo "legal basis example: consistent"

