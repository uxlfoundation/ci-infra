=====================
UXL CI Infrastructure
=====================


Setup system::

    ansible -i inventory playbooks/setup.yml --tags <see playbook>
    
Setup runners::

    gh auth login -s <need to check this>
    scripts/create-runners.sh

