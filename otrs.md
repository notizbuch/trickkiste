#### query OTRS tickets from Centos7 using python script

```
yum install python-setuptools
yum install git
git clone https://github.com/ewsterrenburg/python-otrs.git
(more info on that github page^)
yum install epel-release
yum install python2-defusedxml
```

python script:
```
#!/usr/bin/env python                                   

from otrs.ticket.template import GenericTicketConnectorSOAP                                                     
from otrs.client import GenericInterfaceClient          
from otrs.ticket.objects import Ticket, Article, DynamicField, Attachment                                       

server_uri = r'https://otrs.example.com'            
webservice_name = 'GenericTicketConnectorSOAP'          
client = GenericInterfaceClient(server_uri, tc=GenericTicketConnectorSOAP(webservice_name))                     

# user session                                          
client.tc.SessionCreate(user_login='myuser1', password='mypassword')                                            

tickets = client.tc.TicketSearch(Queues='ActiveIT')     

print tickets                                           
print 'https://otrs.activestate.com/otrs/index.pl?Action=AgentTicketZoom;TicketID=' + str(tickets[0])           

ticket = client.tc.TicketGet(tickets[0], get_articles=True, get_dynamic_fields=True, get_attachments=True)      
print ticket.Title                                      

article = ticket.articles()[0]                          
```
