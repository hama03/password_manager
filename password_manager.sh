#!/bin/bash

PASSWORD_FILE="passwords.txt"
ENCRYPTED_FILE="passwords.txt.gpg"

echo "パスワードマネージャーへようこそ！"

while true; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read choice

    case $choice in
        "Add Password")
            echo "サービス名を入力してください："
            read service
            echo "ユーザー名を入力してください："
            read username
            echo "パスワードを入力してください："
            read password
            
            # 復号化して追記
            gpg --decrypt $ENCRYPTED_FILE 2> /dev/null > $PASSWORD_FILE || true
            echo "$service:$username:$password" >> $PASSWORD_FILE
            # 再度暗号化
            gpg -c $PASSWORD_FILE
            rm $PASSWORD_FILE
            ;;

        "Get Password")
            echo "サービス名を入力してください："
            read service
            
            # 一時的に復号化して検索
            gpg --decrypt $ENCRYPTED_FILE 2> /dev/null > $PASSWORD_FILE || true
            result=$(grep "^$service:" $PASSWORD_FILE)

            if [ -z "$result" ]; then
                echo "そのサービスは登録されていません。"
            else
                IFS=":" read -ra parts <<< "$result"
                echo "サービス名：${parts[0]}"
                echo "ユーザー名：${parts[1]}"
                echo "パスワード：${parts[2]}"
            fi
            
            rm $PASSWORD_FILE
            ;;

        "Exit")
            echo "Thank you!"
            exit 0
            ;;
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done
