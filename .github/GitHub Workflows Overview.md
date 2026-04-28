# GitHub Workflows Overview

This repository includes several automated workflows located in `.github/workflows`. These workflows provide consistent linting, security scanning, and Terraform validation across all projects created from this template.

## Initial Setup - GitHub UI 

Before using this template, complete the following one‑time steps in the GitHub UI.

### 1. Enable the following Dependabot features:

*Settings -> Advanced Security -> Dependabot*

- `Dependabot alerts`
- `Dependabot security updates`
- `Grouped security updates`
- `Dependabot version updates`

### 2. Enable the following Code scanning features:

*Settings -> Advanced Security -> Code scanning -> Tools*

- `CodeQL analysis (default)`
- `Copilot Autofix`

### 3. Create the required workflow labels

*Issues -> Rules -> New label -> Create label*

- `dependencies`
- `github-actions`

> **Note:** Further labels will need to be added depending on the languages used in the project.

### 4. Create the additional standard repository branches

*Code -> Branch dropdown -> view all branches -> New branch*

- `development`
- `staging`

### 5. Import each JSON file into GitHub Rulesets:

*Settings -> Rules -> New ruleset*

- `dev‑branch.json`
- `stage‑branch.json`
- `main‑branch.json`

## Initial Setup - Workflows

**Configure the workflows below using project-relevant languages.**

### 1. `lint.yml`

*.github\workflows\lint.yml*

**Example:**

```yaml
      - name: Python Lint
        run: |
          pip install flake8
          flake8 .
```

Runs on all branches. This workflow performs general repository linting: YAML linting, markdown linting, and basic formatting checks. Its purpose is to ensure consistent structure and formatting across all repos created from this template.

### 2. `security.yml`

*.github\workflows\security.yml*

**Example:**

```yaml
codeql:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v3
      with:
        languages: python

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
```

Runs on all branches. This workflow performs static analysis using GitHub CodeQL. It helps identify potential security issues early in development.

### 3. `dependabot.yml`

*.github\dependabot.yml*

```yaml
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "monthly"
    labels:
      - "dependencies"
      - "python"
    commit-message:
      prefix: "deps:"
      include: "scope"
```

Dependabot is configured to check for GitHub Actions updates once per month. It will open PRs only when updates exist using a consistent commit message prefix: ci:.

### 4. `terraform.yml`

*.github\dependabot.yml*

No initial configuration required

Runs where Terraform is used. This workflow runs terraform fmt, terraform init -backend=false, and terraform validate to ensure the Terraform code is syntax error-free and properly formatted before merging.

## Pull Request Template

Located at `.github/PULL_REQUEST_TEMPLATE.md`. This template provides a consistent structure for all pull requests created from this repository template.

## Additional Testing

This template repository includes only generic workflows. Projects created from this template may require additional testing workflows depending on the languages or frameworks used, such as Unit tests, integration tests, vetting, type checking, module verification, policy checks, static analysis, and UI tests.

## Further Documentation

- [Workflows documentation](https://docs.github.com/en/actions/tutorials/build-and-test-code)
- [Dependabot documentation](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-dependabot-version-updates)
