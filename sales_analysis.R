# Synthetic retail sales analysis (no personal data)
# Run from the project root: source("R/sales_analysis.R")
set.seed(400)
orders <- data.frame(
  order_id = sprintf("ORD%03d", 1:120),
  month = rep(c("Jan", "Feb", "Mar", "Apr"), each = 30),
  category = rep(c("Books", "Office", "Tech"), times = 40),
  units = sample(1:5, 120, replace = TRUE),
  unit_price = rep(c(18, 32, 75), times = 40)
)
orders$revenue <- orders$units * orders$unit_price
monthly <- aggregate(revenue ~ month, orders, sum)
monthly$month <- factor(monthly$month, levels = c("Jan", "Feb", "Mar", "Apr"))
monthly <- monthly[order(monthly$month), ]
category_totals <- aggregate(revenue ~ category, orders, sum)
stopifnot(nrow(orders) == 120, all(orders$revenue >= 0),
          isTRUE(all.equal(sum(monthly$revenue), sum(orders$revenue))),
          isTRUE(all.equal(sum(category_totals$revenue), sum(orders$revenue))))
if (!dir.exists("outputs")) dir.create("outputs")
write.csv(monthly, "outputs/monthly_revenue.csv", row.names = FALSE)
write.csv(category_totals, "outputs/category_revenue.csv", row.names = FALSE)
png("outputs/monthly_revenue.png", width = 900, height = 540)
barplot(monthly$revenue, names.arg = as.character(monthly$month),
        col = "steelblue", main = "Monthly Revenue (Synthetic Data)",
        xlab = "Month", ylab = "Revenue (CAD)")
dev.off()
cat("Orders:", nrow(orders), "\nTotal revenue:", sum(orders$revenue), "\n")
