#!/bin/bash

# https://gist.github.com/detiber/81b515df272f5911959e81e39137a8bb

DIR=$(dirname "$(readlink -fn "$0")")

DIR=$DIR/tmp2
mkdir -p $DIR;

###############################################################
cat << EOF > $DIR/root-ca-config.json
{
    "signing": {
        "profiles": {
            "intermediate": {
                "usages": [
                    "signature",
                    "digital-signature",
                    "cert sign",
                    "crl sign"
                ],
                "expiry": "438000h",
                "ca_constraint": {
                    "is_ca": true,
                    "max_path_len": 0,
                    "max_path_len_zero": true
                }
            }
        }
    }
}
EOF

cat << EOF > $DIR/etcd-ca-config.json
{
    "signing": {
        "profiles": {
            "server": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF




cat <<EOF > $DIR/kubernetes-ca-config.json
{
    "signing": {
        "default": {
            "expiry": "438000h"
        },
        "profiles": {
            "www": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            }
        }
    }
}
EOF

cat <<EOF > $DIR/kubernetes-front-proxy-ca-config.json
{
    "signing": {
        "default": {
            "expiry": "438000h"
        },
        "profiles": {
            "www": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "438000h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            }
        }
    }
}
EOF

###############################################################

cat << EOF > $DIR/root-ca-csr.json
{
    "CN": "my-root-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "438000h"
    }
}
EOF


cat << EOF > $DIR/etcd-ca-csr.json
{
    "CN": "etcd-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "438000h"
    },
    "names": [{
	    "C": "CN",
	    "ST": "Shanghai",
	    "L": "Shanghai",
	    "O": "PIX Inc.",
	    "OU": "Etcd CA"
    }]
}
EOF

cat << EOF > $DIR/kubernetes-ca-csr.json
{
    "CN": "kubernetes-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "438000h"
    },
    "names": [{
	    "C": "CN",
	    "ST": "Shanghai",
	    "L": "Shanghai",
	    "O": "PIX Inc.",
	    "OU": "Kubernetes CA"
    }]
}
EOF

cat << EOF > $DIR/kubernetes-front-proxy-ca-csr.json
{
    "CN": "kubernetes-front-proxy-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "438000h"
    },
    "names": [{
	    "C": "CN",
	    "ST": "Shanghai",
	    "L": "Shanghai",
	    "O": "PIX Inc.",
	    "OU": "Kubernetes front CA"
    }]    
}
EOF


###############################################################

cat << EOF > $DIR/etcd-server-csr.json
{
  "CN": "kube-etcd",
  "hosts": [
    "ubuntu",
    "192.168.33.11",
    "192.168.33.12",
    "192.168.33.13",
    "localhost",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
EOF

cat << EOF > $DIR/etcd-peer-csr.json
{
  "CN": "kube-etcd-peer",
  "hosts": [
    "ubuntu",
    "192.168.33.11",
    "192.168.33.12",
    "192.168.33.13",
    "localhost",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
EOF


cat << EOF > $DIR/etcd-healthcheck-client-csr.json
{
  "CN": "kube-etcd-healthcheck-client",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
      {
          "O": "system:masters"
      }
  ]
}
EOF


cat << EOF > $DIR/apiserver-csr.json
{
  "CN": "kubernetes",
  "hosts": [
    "n21",
    "n22",
    "n23",    
    "192.168.33.100",
    "192.168.33.21", 
    "192.168.33.22", 
    "192.168.33.23",
    "10.254.0.1",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
EOF

cat << EOF > $DIR/apiserver-kubelet-client-csr.json
{
  "CN": "kube-apiserver-kubelet-client",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
    {
      "O": "system:masters"
    }
  ]
}
EOF

cat << EOF > $DIR/front-proxy-client-csr.json
{
  "CN": "front-proxy-client",
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
EOF

cat << EOF > $DIR/apiserver-etcd-client-csr.json
{
  "CN": "kube-apiserver-etcd-client",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
      {
          "O": "system:masters"
      }
  ]
}
EOF


cat << EOF > $DIR/admin-csr.json
{
  "CN": "kubernetes-admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
    {
      "O": "system:masters"
    }
  ]
}
EOF

cat << EOF > $DIR/kube-controller-manager-csr.json
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [{
	"C": "CN",
	"ST": "Shanghai",
	"L": "Shanghai",
	"O": "PIX Inc.",
	"OU": "Web Security"
    }]
}
EOF

cat << EOF > $DIR/kube-scheduler-csr.json
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 4096
  }
}
EOF



cat <<EOF > $DIR/kube-proxy-csr.json
{
	"CN": "system:kube-proxy",
	"key": {
		"algo": "rsa",
		"size": 4096
	},
	"names": [{
		"C": "CN",
		"ST": "Shanghai",
		"L": "Shanghai",
		"O": "PIX Inc.",
		"OU": "Web Security"
	}]
}
EOF







# root-ca 
cfssl genkey -initca $DIR/root-ca-csr.json | cfssljson -bare $DIR/ca

# kubernetes-ca
cfssl genkey -initca $DIR/kubernetes-ca-csr.json | cfssljson -bare $DIR/kubernetes-ca
cfssl sign -ca $DIR/ca.pem -ca-key $DIR/ca-key.pem -config $DIR/root-ca-config.json -profile intermediate $DIR/kubernetes-ca.csr | cfssljson -bare $DIR/kubernetes-ca


# kubernetes-front-proxy-ca
cfssl genkey -initca $DIR/kubernetes-front-proxy-ca-csr.json | cfssljson -bare $DIR/kubernetes-front-proxy-ca
cfssl sign -ca $DIR/ca.pem -ca-key $DIR/ca-key.pem -config $DIR/root-ca-config.json -profile intermediate $DIR/kubernetes-front-proxy-ca.csr | cfssljson -bare $DIR/kubernetes-front-proxy-ca

# etcd-ca
cfssl genkey -initca $DIR/etcd-ca-csr.json | cfssljson -bare $DIR/etcd-ca
cfssl sign -ca $DIR/ca.pem -ca-key $DIR/ca-key.pem -config $DIR/root-ca-config.json -profile intermediate $DIR/etcd-ca.csr | cfssljson -bare $DIR/etcd-ca

# etcd 
cfssl gencert -ca=$DIR/etcd-ca.pem -ca-key=$DIR/etcd-ca-key.pem --config=$DIR/etcd-ca-config.json -profile=peer $DIR/etcd-server-csr.json | cfssljson -bare $DIR/etcd-server
cfssl gencert -ca=$DIR/etcd-ca.pem -ca-key=$DIR/etcd-ca-key.pem --config=$DIR/etcd-ca-config.json -profile=peer $DIR/etcd-peer-csr.json | cfssljson -bare $DIR/etcd-peer
cfssl gencert -ca=$DIR/etcd-ca.pem -ca-key=$DIR/etcd-ca-key.pem --config=$DIR/etcd-ca-config.json -profile=client $DIR/etcd-healthcheck-client-csr.json | cfssljson -bare $DIR/etcd-healthcheck-client


# k8s serverapi
cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=www    $DIR/apiserver-csr.json | cfssljson -bare $DIR/apiserver
cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=client $DIR/apiserver-kubelet-client-csr.json | cfssljson -bare $DIR/apiserver-kubelet-client
cfssl gencert -ca=$DIR/etcd-ca.pem       -ca-key=$DIR/etcd-ca-key.pem       --config=$DIR/etcd-ca-config.json       -profile=client $DIR/apiserver-etcd-client-csr.json | cfssljson -bare $DIR/apiserver-etcd-client

# k8s kubelet 

cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=client $DIR/kube-controller-manager-csr.json | cfssljson -bare $DIR/kube-controller-manager
cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=client $DIR/kube-scheduler-csr.json | cfssljson -bare $DIR/kube-scheduler
cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=client $DIR/kube-proxy-csr.json | cfssljson -bare $DIR/kube-proxy


# front-proxy

cfssl gencert -ca=$DIR/kubernetes-front-proxy-ca.pem -ca-key=$DIR/kubernetes-front-proxy-ca-key.pem --config=$DIR/kubernetes-front-proxy-ca-config.json -profile=client $DIR/front-proxy-client-csr.json | cfssljson -bare $DIR/front-proxy-client

# kubectl

cfssl gencert -ca=$DIR/kubernetes-ca.pem -ca-key=$DIR/kubernetes-ca-key.pem --config=$DIR/kubernetes-ca-config.json -profile=client $DIR/admin-csr.json | cfssljson -bare $DIR/admin



chmod 600 $DIR/*-key.pem



#openssl genrsa -out sa.key 2048
#openssl rsa -in sa.key -pubout -out sa.pub

#chmod 600 *-key.pem

