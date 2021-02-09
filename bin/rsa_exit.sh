if [ -e ./packer/ansible/roles/common/files/id_rsa ];then
  echo "id_rsa ok"
else
  echo "Please Set id_rsa"
  exit
fi

if [ -e ./packer/ansible/roles/common/files/id_rsa.pub ];then
  echo "id_rsa.pub ok"
else
  echo "Please Set id_rsa.pub"
  exit
fi
