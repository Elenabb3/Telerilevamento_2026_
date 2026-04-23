library(qrcode)
qr <- qr_code(url)
setwd(C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop\\uni\\telerilevamento")

png("github_profile_qr.png", width = 1000, height = 1000)
plot(qr)
dev.off()

