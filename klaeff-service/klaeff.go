package main

import (
	_ "embed"
	"fmt"
	"net/http"
)

const (
	Version = "0.0.0-dev"
)

var (

	//go:embed static/index.html
	indexFile []byte
	//go:embed static/klaeff-banner.txt
	bannerFile []byte
	//go:embed static/img/klaeff-logo.png
	logoImage []byte
	//go:embed static/img/klaeff-impressum.png
	impressumImage []byte
)

func main() {

	fmt.Println(string(bannerFile))

	http.Handle("/", http.HandlerFunc(handleKlaeffIndexRequest))
	http.Handle("/version", http.HandlerFunc(handleKlaeffVersionRequest))
	http.Handle("/logo", http.HandlerFunc(handleKlaeffLogoRequest))
	http.Handle("/impressum", http.HandlerFunc(handleKlaeffImpressumRequest))
	http.Handle("/health", http.HandlerFunc(handleKlaeffHealthRequest))
	http.Handle("/ready", http.HandlerFunc(handleKlaeffReadyRequest))

	fmt.Println("Server started at port 8080")
	http.ListenAndServe(":8080", nil)

}

func handleKlaeffIndexRequest(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "text/html; charset=utf-8")
	w.Write(indexFile)
}

func handleKlaeffHealthRequest(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "text/plain; charset=utf-8")
	w.Write([]byte("1"))
}

func handleKlaeffReadyRequest(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "text/plain; charset=utf-8")
	w.Write([]byte("1"))
}

func handleKlaeffVersionRequest(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	fmt.Fprintf(w, "{\"version\": \""+Version+"\"}")
}

func handleKlaeffLogoRequest(w http.ResponseWriter, r *http.Request) {
	w.Write(logoImage)
	w.Header().Add("Content-Type", "image/png")
}

func handleKlaeffImpressumRequest(w http.ResponseWriter, r *http.Request) {
	w.Write(impressumImage)
	w.Header().Add("Content-Type", "image/png")
}
