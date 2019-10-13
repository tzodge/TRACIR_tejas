import cv2
# insert image path
PATH = "data_14Sep_2/us_image001.jpg"
img = cv2.imread(PATH)
cv2.imshow("img",img)
cv2.waitKey(0)
