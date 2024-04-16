install:
	@poetry install

install_jupyter:
	@poetry add jupyter ipykernel
	@$(eval code_path=$(shell find /vscode/vscode-server/bin/ -name code | head -n 1))
	@python -m ipykernel install --user --name=poetry_env --display-name="Python (poetry)"
	@${code_path} --install-extension ms-toolsai.jupyter

install_all:
	@make install
	@make install_jupyter