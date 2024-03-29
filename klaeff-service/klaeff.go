package main

import (
	_ "embed"
	"fmt"
	"log"
	"net/http"
	"os"
)

var (
	version = "0.0.0-dev"
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
	//go:embed static/img/favicon.ico
	faviconImage []byte
)

func main() {

	fmt.Println(string(bannerFile))

	port := os.Getenv("PORT")
	if port == "" {
		port = fmt.Sprintf(":%v", 8080)
	} else {
		port = fmt.Sprintf(":%v", port)
	}

	http.Handle("/", http.HandlerFunc(handleKlaeffIndexRequest))
	http.Handle("/version", http.HandlerFunc(handleKlaeffVersionRequest))
	http.Handle("/logo", http.HandlerFunc(handleKlaeffLogoRequest))
	http.Handle("/impressum", http.HandlerFunc(handleKlaeffImpressumRequest))
	http.Handle("/health", http.HandlerFunc(handleKlaeffHealthRequest))
	http.Handle("/ready", http.HandlerFunc(handleKlaeffReadyRequest))
	http.Handle("/favicon.ico", http.HandlerFunc(handleKlaeffFaviconRequest))

	log.Printf("Server version %v started at port %v", version, port)
	err := http.ListenAndServe(port, nil)
	if err != nil {
		log.Printf("%v\n", err)
	}
}

func handleKlaeffIndexRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Header().Add("Content-Type", "text/html; charset=utf-8")
	w.Write(indexFile)
}

func handleKlaeffHealthRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Header().Add("Content-Type", "text/plain; charset=utf-8")
	w.Write([]byte("1"))
}

func handleKlaeffReadyRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Header().Add("Content-Type", "text/plain; charset=utf-8")
	w.Write([]byte("1"))
}

func handleKlaeffVersionRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	fmt.Fprintf(w, "{\"version\": \""+version+"\"}")
}

func handleKlaeffLogoRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Write(logoImage)
	w.Header().Add("Content-Type", "image/png")
}

func handleKlaeffImpressumRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Write(impressumImage)
	w.Header().Add("Content-Type", "image/png")
}

func handleKlaeffFaviconRequest(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request: %v %v", r.Method, r.RequestURI)
	w.Write(faviconImage)
	w.Header().Add("Content-Type", "image/x-icon")
}
