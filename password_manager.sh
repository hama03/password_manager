#!/bin/bash

# パスワード情報を保存するファイルのパス
PASSWORD_FILE="passwords.txt"

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

            # 入力された情報をファイルに保存
            echo "$service:$username:$password" >> $PASSWORD_FILE

            echo "パスワードの追加は成功しました。"
            ;;

        "Get Password")
            echo "サービス名を入力してください："
            read service
            # 入力されたサービス名に対応する情報を抽出
            result=$(grep "^$service:" $PASSWORD_FILE)

            if [ -z "$result" ]; then
                echo "そのサービスは登録されていません。"
            else
                IFS=":" read -ra parts <<< "$result"
                echo "サービス名：${parts[0]}"
                echo "ユーザー名：${parts[1]}"
                echo "パスワード：${parts[2]}"
            fi
            ;;

        "Exit")
            echo "Thank you!"
            break
            ;;

        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done
