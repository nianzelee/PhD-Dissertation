benchmark-xml = test-sets
raw-data = thesis-data
timelimit = 900s
memlimit = 15GB
flag-resource = -T $(timelimit) -M $(memlimit)

ppe-experiments:
	@benchexec $(flag-resource) $(benchmark-xml)/bddsp-pec.xml $(benchmark-xml)/dcssat-pec.xml \
        $(benchmark-xml)/cachet-pec.xml $(benchmark-xml)/approxmc-pec.xml
	@benchexec $(flag-resource) $(benchmark-xml)/bddsp-mpec.xml $(benchmark-xml)/dcssat-mpec.xml 
ressat-experiments:
	@benchexec $(flag-resource) $(benchmark-xml)/dcssat-re.xml $(benchmark-xml)/ressat.xml
erssat-experiments:
	@benchexec $(flag-resource) $(benchmark-xml)/dcssat-er.xml $(benchmark-xml)/erssat.xml
ppe-tables:
	@firefox $(raw-data)/PEC-D-0.01.table.html &
	@firefox $(raw-data)/PEC-D-0.10.table.html &
	@firefox $(raw-data)/MPEC-D-0.01.table.html &
	@firefox $(raw-data)/MPEC-D-0.10.table.html &
ressat-tables:
	@firefox $(raw-data)/ressat-Random.table.html &
	@firefox $(raw-data)/ressat-Strategic.table.html &
	@firefox $(raw-data)/ressat-PEC.table.html &
erssat-tables:
	@firefox $(raw-data)/erssat-Random.table.html &
	@firefox $(raw-data)/erssat-Application.table.html &
clean:
	@rm results -rf
