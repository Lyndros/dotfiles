
#!/usr/bin/env bash
selected=`cat $HOME/.cht-languages $HOME/.cht-commands | fzf`
echo $selected
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" $HOME/.cht-languages; then
    query=`echo $query | tr ' ' '+'`
    bash -c "echo \"curl cht.sh/$selected/$query/\" && curl cht.sh/$selected/$query"
else
    bash -c "curl -s cht.sh/$selected~$query"
fi

