#!/bin/bash
# chmod +x auto_serw.sh

while true; do
  
    echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"
    echo "1. Instalacja serwera FiveM"
    echo "2. Instalacja bazy danych (mysql) + dbms phpmyadmin"
    echo "3. Instalacja bazy danych (mysql), serwera FiveM i dbms (phpmyadmin)"
    echo "4. Wyjście"
    echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"

    # Pobranie wyboru od użytkownika
    read -p "Wybierz opcję [1-4]: " choice

    # Wykonanie akcji na podstawie wyboru
    case $choice in
        1)
            echo "Wybrałeś opcję numer 1, trwa inicjowanie..."
               # Aktualizacja systemu
                sudo apt update
                sudo apt upgrade -y
                sudo apt install xz-utils -y 
                sudo apt install git -y

                # Przejście do katalogu /home i pobranie niezbędnych plików
                cd /home
                git clone https://github.com/citizenfx/cfx-server-data
                mkdir fx-server
                cd fx-server
                # -- CZASOWE ROZWIĄZANIE    
                wget -q --show-progress "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/8216-0fc6406b3f3c18243761d0d4dfa0fdfd4d0aeed6/fx.tar.xz" -O fx.tar.xz

                tar -xf fx.tar.xz
            
                cd ../cfx-server-data
                # Zadawanie pytań i zapisywanie odpowiedzi w zmiennych
                read -p "Podaj nazwę serwera: " server_name
                read -p "Podaj użytkownika bazy danych: " db_user
                read -p "Podaj hasło bazy danych: " db_password
                read -p "Podaj nazwę bazy danych, z której będzie korzystała paczka: " db_name

                # Tworzenie zawartości pliku server.cfg
                server_cfg_content="
#======================== POLACY2017 AUTO-SERWER CREATOR ========================#
sv_hostname \"$server_name\" #Nazwa
sets sv_projectName \"$server_name\" #Nazwa
sets sv_projectDesc \"$server_name\" #Krótki opis

# <--- Endpoints ---> #
endpoint_add_tcp \"0.0.0.0:30120\"
endpoint_add_udp \"0.0.0.0:30120\"
sv_endpointPrivacy true

# <--- ScriptHook ---> #
sv_scriptHookAllowed 0

# <--- Database ---> #
set mysql_connection_string \"mysql://$db_user:$db_password@localhost/$db_name?waitForConnections=true&charset=utf8mb4\"

# <--- Slots ---> #
sv_maxclients 5 #Maksymalne sloty

# <--- Tags ---> #
sets tags \"POLACY2017 SERVER CREATOR\"

# <--- Keys ---> #
set steam_webApiKey none #Jezeli potrzebujesz wpisz api keya
sv_licenseKey \"WPISZ LICENCJE\"

#======================== POLACY2017 AUTO-SERWER CREATOR ========================#"

                # Zapisanie zawartości do pliku server.cfg
                echo "$server_cfg_content" > server.cfg
                IP=$(hostname -I | awk '{print $1}')
                echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"
                echo "Instalacja zakończona. Pliki znajdziesz na serwerze S/FTP w lokalizacji /home/"
                echo "DOSTEP SFTP: "
                echo "IP: $IP"
                echo "Port: 22/21"
                echo "Użytkownik: root"
                echo "Hasło: Uzywane do logowania na maszyne"
                echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"

                break
            ;;
            
        2)
            echo "Wybrałeś opcję numer 2, trwa inicjowanie..."
            echo -n "Wpisz jakie chcesz mieć hasło do bazy danych: "
            read -s password
            echo

            IP=$(hostname -I | awk '{print $1}')
            sudo apt update
            sudo apt upgrade -y

            sudo apt install -y mariadb-server mariadb-client

            # Uruchomienie i sprawdzenie statusu serwera
            sudo systemctl start mariadb
            sudo systemctl enable mariadb
            sudo systemctl status mariadb
            if [ $? -ne 0 ]; then
                echo "Błąd: Serwer MariaDB nie uruchomił się poprawnie."
                exit 1
            fi

            # Konfiguracja zabezpieczeń MariaDB
            sudo apt install expect -y
            expect -c "
            set timeout 3
            spawn sudo mysql_secure_installation
            expect \"Enter current password for root (enter for none):\"
            send \"\r\"
            expect \"Change the root password?\"
            send \"n\r\"
            expect \"Remove anonymous users?\"
            send \"y\r\"
            expect \"Disallow root login remotely?\"
            send \"y\r\"
            expect \"Remove test database and access to it?\"
            send \"y\r\"
            expect \"Reload privilege tables now?\"
            send \"y\r\"
            expect eof
            "

        
            sudo mysql -u root -p"$password" -e "
                CREATE USER 'admin'@'%' IDENTIFIED BY '$password';
                GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
                FLUSH PRIVILEGES;
                CREATE DATABASE IF NOT EXISTS polacy2017_creator;
            "

      
          
           

            sudo apt install -y wget unzip apache2 php php-cli php-mbstring php-zip php-gd php-json php-curl
            sudo apt install -y phpmyadmin

            sudo phpenmod mbstring
            sudo systemctl restart apache2

            echo 'Include /etc/phpmyadmin/apache.conf' | sudo tee /etc/apache2/conf-available/phpmyadmin.conf

            sudo a2enconf phpmyadmin
            sudo systemctl reload apache2

            echo -e "\e[34m======================== POLACY2017 AUTO-SERWER CREATOR ========================\e[0m"
            echo "Instalacja zakończona. Możesz uzyskać dostęp do phpMyAdmin pod adresem http://$IP/phpmyadmin"
            echo "Użytkownik: admin"
            echo "Hasło: ${password}"
            echo -e "\e[34m======================== POLACY2017 AUTO-SERWER CREATOR ========================\e[0m"
            
            ;;

        3)
            echo "Wybrałeś opcję numer 3, trwa inicjowanie..."


             echo -n "Wpisz jakie chcesz mieć hasło do bazy danych: "
            read -s password
            echo

            IP=$(hostname -I | awk '{print $1}')
            sudo apt update
            sudo apt upgrade -y

            sudo apt install -y mariadb-server mariadb-client

            # Uruchomienie i sprawdzenie statusu serwera
            sudo systemctl start mariadb
            sudo systemctl enable mariadb
            sudo systemctl status mariadb
            if [ $? -ne 0 ]; then
                echo "Błąd: Serwer MariaDB nie uruchomił się poprawnie."
                exit 1
            fi

            # Konfiguracja zabezpieczeń MariaDB
            sudo apt install expect -y
            expect -c "
            set timeout 1
            spawn sudo mysql_secure_installation
            expect \"Enter current password for root (enter for none):\"
            send \"\r\"
            expect \"Change the root password?\"
            send \"n\r\"
            expect \"Remove anonymous users?\"
            send \"y\r\"
            expect \"Disallow root login remotely?\"
            send \"y\r\"
            expect \"Remove test database and access to it?\"
            send \"y\r\"
            expect \"Reload privilege tables now?\"
            send \"y\r\"
            expect eof
            "

            # Zmiana metody uwierzytelniania na mysql_native_password
            sudo mysql -u root -p"$password" -e "
                CREATE USER 'admin'@'%' IDENTIFIED BY '$password';
                GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
                FLUSH PRIVILEGES;
                CREATE DATABASE IF NOT EXISTS polacy2017_creator;
            "

      
          
           

            sudo apt install -y wget unzip apache2 php php-cli php-mbstring php-zip php-gd php-json php-curl
            sudo apt install -y phpmyadmin

            sudo phpenmod mbstring
            sudo systemctl restart apache2

            echo 'Include /etc/phpmyadmin/apache.conf' | sudo tee /etc/apache2/conf-available/phpmyadmin.conf

            sudo a2enconf phpmyadmin
          






                echo -e "\e[34m======================== SERWER ========================\e[0m"
                sudo apt install xz-utils -y 
                sudo apt install git -y

                # Przejście do katalogu /home i pobranie niezbędnych plików
                cd /home
                git clone https://github.com/citizenfx/cfx-server-data
                mkdir fx-server
                cd fx-server
                # -- CZASOWE ROZWIĄZANIE    
                wget -q --show-progress "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/8216-0fc6406b3f3c18243761d0d4dfa0fdfd4d0aeed6/fx.tar.xz" -O fx.tar.xz

                tar -xf fx.tar.xz
            
                cd ../cfx-server-data
             

                read -p "Podaj nazwę serwera: " server_name
         


                # Tworzenie zawartości pliku server.cfg
                server_cfg_content="
#======================== POLACY2017 AUTO-SERWER CREATOR ========================#
sv_hostname \"$server_name\" #Nazwa
sets sv_projectName \"$server_name\" #Nazwa
sets sv_projectDesc \"$server_name\" #Krótki opis

# <--- Endpoints ---> #
endpoint_add_tcp \"0.0.0.0:30120\"
endpoint_add_udp \"0.0.0.0:30120\"
sv_endpointPrivacy true

# <--- ScriptHook ---> #
sv_scriptHookAllowed 0

# <--- Database ---> #
set mysql_connection_string \"mysql://admin:$password@localhost/polacy2017_creator?waitForConnections=true&charset=utf8mb4\"

# <--- Slots ---> #
sv_maxclients 5 #Maksymalne sloty

# <--- Tags ---> #
sets tags \"POLACY2017 SERVER CREATOR\"

# <--- Keys ---> #
set steam_webApiKey none #Jezeli potrzebujesz wpisz api keya
sv_licenseKey \"WPISZ LICENCJE\"

#======================== POLACY2017 AUTO-SERWER CREATOR ========================#"

                # Zapisanie zawartości do pliku server.cfg
                echo "$server_cfg_content" > server.cfg








  

           
            
            echo -e "\e[34m======================== POLACY2017 AUTO-SERWER CREATOR ========================\e[0m"
            echo "Instalacja zakończona. Możesz uzyskać dostęp do phpMyAdmin pod adresem http://$IP/phpmyadmin"
            echo "Użytkownik: admin"
            echo "Hasło: ${password}"
            echo "Domyślna baza danych podłączona do cfg: polacy2017_creator"
            echo -e "\e[34m======================== POLACY2017 AUTO-SERWER CREATOR ========================\e[0m"



            sudo systemctl reload apache2












                echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"
                echo "Instalacja zakończona. Pliki znajdziesz na serwerze S/FTP w lokalizacji /home/"
                echo "DOSTEP SFTP: "
                echo "IP: $IP"
                echo "Port: 22/21"
                echo "Użytkownik: root"
                echo "Hasło: Uzywane do logowania na maszyne"
                echo "======================== POLACY2017 AUTO-SERWER CREATOR ========================"







            break
            ;;  
        4)
            echo "Dziękuje za skorzystanie z Creatora!"
            break
            ;;
        *)
            echo "Wybrałeś nieistniejącą opcję, wybierz ponownie."
            ;;
    esac
done