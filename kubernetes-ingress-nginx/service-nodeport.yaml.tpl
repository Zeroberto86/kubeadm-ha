apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
  labels:
    app: ingress-nginx    
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
  externalIPs:
  - K8SHA_VIP
  - K8SHA_IP1
  - K8SHA_IP2
  - K8SHA_IP3
  selector:
    app: ingress-nginx  
