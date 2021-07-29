terraform-apply:
	cd terraform && terraform apply

terraform-plan:
	cd terraform && terraform plan

terraform-destroy:
	cd terraform && terraform destroy

deploy:
		cd ansible && ansible-playbook -i hosts.ini playbook.yml --ask-vault-pass
