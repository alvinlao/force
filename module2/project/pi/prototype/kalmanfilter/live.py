from __builtin__ import abs
import cv2
import cv2.cv as cv
import time
from random import *
from helper import *
from colortracker import *
from kalmanfilter import *

frame = None
roiPts = []
inputMode = False

def selectROI(event, x, y, flags, param):
    # Grab the reference to the current frame, list of ROI
    # points and whether or not it is ROI selection mode
    global frame, roiPts, inputMode

    # If we are in ROI selection mode, the mouse was clicked
    # and we do not already have four points, then update the
    # list of ROI points with the (x, y) location of the click
    # and draw the circle
    if inputMode and event == cv.CV_EVENT_LBUTTONDOWN and len(roiPts) < 4:
        roiPts.append((x, y))
        cv2.circle(frame, (x, y), 4, (0, 255, 0), 2)
        cv2.imshow("frame", frame)


def main():
    global frame, roiPts, inputMode

    cv2.setMouseCallback("Video", selectROI)

    # Setup camera
    CAMERA_INDEX = 0
    cv.NamedWindow("Video", cv.CV_WINDOW_AUTOSIZE)
    capture = cv.CaptureFromCAM(CAMERA_INDEX)

    camera = cv2.VideoCapture()

    # Get width and height
    frame = cv.QueryFrame(capture)
    width, height = cv.GetSize(frame)
    print(width, height)

    termination = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 1)
    roiBox = None

    #Tracking Algorithm
    ct = ColorTracker(frame_width=320, frame_height=240, color=(0, 0, 0), n=1)

    # Particle filter runs at about 0.03s/iteration
    # This value is just an arbitrarily chosen one
    timestep = 0.000001

    # Create Kalman
    kalman = cv.CreateKalman(4, 2, 0)
    kalman_state = cv.CreateMat(4, 1, cv.CV_32FC1)
    kalman_process_noise = cv.CreateMat(4, 1, cv.CV_32FC1)
    kalman_measurement = cv.CreateMat(2, 1, cv.CV_32FC1)

    """
    # Initiation of state matrices
    # X(distance_x, distance_y, velocity_x, velocity_y)
    X = np.array([[0], [0], [0], [0]])

    A = np.array([[1, 0, timestep, 0], [0, 1, 0, timestep], [0, 0, 1, 0],
                  [0, 0, 0, 1]])

    R = np.identity(4)*20

    prev = ct.track(frame)[0]
    new = ct.track(frame)[0]

    dist_x = abs(new.x - prev.x)
    dist_y = abs(new.y - prev.y)
    Z = np.array([[dist_x], [dist_y], [dist_x/timestep], [dist_y/timestep]])

    kalman = Kalman(X, A, Z, R)

    kf = KalmanFilter(320, 240, kalman)
    """

    while True:
        frame = cv.QueryFrame(capture)

        """
        (grabbed, frame2) = camera.read()

        if roiBox is not None:
            hsv = cv2.cvtColor(frame2, cv2.COLOR_BGR2HSV)
            backProj = cv2.calcBackProject([hsv], [0], roiHist, [0, 180], 1)
            (r, roiBox) = cv2.CamShift(backProj, roiBox, termination)
            pts = np.int0(cv2.cv.BoxPoints(r))
            cv2.polylines(frame2, [pts], True, (0, 255, 0), 2)

        #cv2.imshow("Video", frame)
        key = cv2.waitKey(1) & 0xFF

        if key == ord("i") and len(roiPts) < 4:
            inputMode = True
            orig = frame2.copy()

            while len(roiPts) < 4:
                cv2.imshow("frame", frame2)
                cv2.waitKey(0)

            roiPts = np.arrayi(roiPts)
            s = roiPts.sum(axis = 1)
            tl = roiPts[np.argmin(s)]
            br = roiPts[np.argmax(s)]

            roi = orig[[1]:br[1], tl[0]:br[0]]
            roi = cv2.cvtColor(roi, cv2.COLOR_BGR2HSV)

            roiHist = cv2.calcHist([roi], [0], None, [16], [0, 180])
            roiHist = cv2.normalize(roiHist, roiHist, 0, 255, cv2.NORM_MINMAX)
            roiBox = (tl[0], tl[1], br[0], br[1])
        elif key == ord("q"):
            break
        """

        #prev = Point(new.x, new.y, 0)
        new = ct.track(frame)[0]

        x = new.x
        y = new.y

        draw_box(frame, new.x, new.y, WINDOW_SIZE, (0, 0, 255))

        # Setup Kalman
        kalman.state_pre[0, 0] = x
        kalman.state_pre[1, 0] = y
        kalman.state_pre[2, 0] = 0
        kalman.state_pre[3, 0] = 0

        for j in range(4):
            for k in range(4):
                kalman.transition_matrix[j, k] = 0
            kalman.transition_matrix[j, j] = 1

        cv.SetIdentity(kalman.measurement_matrix, cv.RealScalar(1))
        cv.SetIdentity(kalman.process_noise_cov, cv.RealScalar(1e-5))
        cv.SetIdentity(kalman.measurement_noise_cov, cv.RealScalar(1e-1))
        cv.SetIdentity(kalman.error_cov_post, cv.RealScalar(1))

        # Change Kalman Measurement
        kalman_measurement[0, 0] = x
        kalman_measurement[1, 0] = y

        # Prediction Step
        kalman_prediction = cv.KalmanPredict(kalman)
        predict_pt = (kalman_prediction[0, 0], kalman_prediction[1, 0])

        # Correction Step
        kalman_estimated = cv.KalmanCorrect(kalman, kalman_measurement)
        state_pt = (kalman_estimated[0, 0], kalman_estimated[1, 0])

        print (state_pt)

        draw_box(frame, int(state_pt[0]), int(state_pt[1]), WINDOW_SIZE, (0, 255, 0))

        #print new.delta

        cv.ShowImage("w0", frame)

        cv.WaitKey(1)

    """
        dist_x = (new.x - prev.x)
        dist_y = (new.y - prev.y)

        kf.kalman.Z = np.array([[dist_x], [dist_y], [dist_x/timestep], [dist_y/timestep]])

        #print kf.kalman.Z

        kf.run()
        x = kf.kalman.X[0] + prev.x
        y = kf.kalman.X[1] + prev.y

        print(dist_y, kf.kalman.X[1][0])
        #print (prev.x, prev.y)
        #print(kf.kalman.X[0], kf.kalman.X[1])

        x = int(x[0])
        y = int(y[0])

        if (x > 319):
            x = 319
        elif (x < 0):
            x = 0
        if (y > 239):
            y = 239
        elif (y < 0):
            y = 0
    """
if __name__ == '__main__':
    main()
