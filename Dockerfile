FROM airdock/oracle-jdk:1.8

RUN apt-get update && apt-get -y install nginx netcat unzip --no-install-recommends

WORKDIR /usr/local/mirthconnect

ADD templates/mirthconnect/mirthconnect-install-wrapper.sh /usr/local/mirthconnect/mirthconnect-install-wrapper.sh
ADD templates/fhir-3.2.2.7694.b18.zip /usr/local/mirthconnect/extensions/fhir-3.2.2.7694.zip

RUN wget http://downloads.mirthcorp.com/connect/3.2.2.7694.b68/mirthconnect-3.2.2.7694.b68-unix.sh \
 && chmod +x mirthconnect-3.2.2.7694.b68-unix.sh \
 && ./mirthconnect-install-wrapper.sh \
 && cd extensions \
 && unzip fhir-3.2.2.7694.zip \
 && rm fhir-3.2.2.7694.zip \
 && cd ..
 
ADD templates/httpcomponents-client-4.5-bin.zip /usr/local/mirthconnect/custom-lib/httpcomponents-client-4.5-bin.zip 
ADD templates/com.urgentconsult.httpsclient.jar /usr/local/mirthconnect/custom-lib/com.urgentconsult.httpsclient.jar 

RUN cd custom-lib \
 && ls -alh \
 && unzip httpcomponents-client-4.5-bin.zip \
 && rm httpcomponents-client-4.5-bin.zip \
 && cd ..

ADD templates/etc /etc
ADD templates/mirthconnect /usr/local/mirthconnect

EXPOSE 80 443 3000 9661

CMD ./mirthconnect-wrapper.sh
