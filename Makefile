CHART_DIR := harness-delegate-ng
CHART_NAME := $(shell cd $(CHART_DIR) && yq .name Chart.yaml)
CHART_VERSION := $(shell cd $(CHART_DIR) && yq .version Chart.yaml)
CHARTS_DIR := charts

.PHONY: build login deploy

$(CHARTS_DIR):
	mkdir -p $(CHARTS_DIR)

build: $(CHARTS_DIR)
	cd $(CHART_DIR) && helm package . -d ../$(CHARTS_DIR)

login:
	helm registry login \
		$(HARNESS_HELM_BASE_URL) \
		-u $(HARNESS_HELM_USER) \
		-p $(HARNESS_HELM_TOKEN)

deploy:
	helm push $(CHARTS_DIR)/$(CHART_NAME)-$(CHART_VERSION).tgz $(HARNESS_HELM_URL)
